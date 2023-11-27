import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/camera/camera_bloc.dart';
import 'package:face_commute/ui/camera/camera_event.dart';
import 'package:face_commute/ui/camera/state/camera_error_state.dart';
import 'package:face_commute/ui/camera/state/camera_state.dart';
import 'package:face_commute/ui/camera/view/camera_view_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rxdart/rxdart.dart';

extension on BuildContext {
  CameraViewController get controller => CameraViewController(this);
}

final class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

final class _CameraViewState extends State<CameraView> {
  final GlobalKey<State<StatefulWidget>> globalKey = GlobalKey();

  late final CameraController _cameraController = CameraController(
    context.controller.state.model.cameraDescription,
    ResolutionPreset.high,
    enableAudio: false,
  );
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  // 카메라 이미지 스트림을 분석하여 얼굴을 인식하는 Subject
  final PublishSubject<CameraImage> _cameraImageSubject = PublishSubject();

  // 현재 운동 지속 시간을 저장하는 Subject
  late final PublishSubject<Duration> _durationSubject = PublishSubject();

  // 얼굴 인식이 성공적으로 되었는지 체크하는 Subject
  final BehaviorSubject<bool> _isFaceDetectedSubject = BehaviorSubject.seeded(false);

  final List<StreamSubscription> _subscriptions = [];

  Stream<Duration> get _durationStream => Stream.periodic(Values.milliseconds, (_) => Values.milliseconds)
      .startWith(Values.milliseconds)
      .withLatestFrom<bool, Duration>(_isFaceDetectedSubject, (t, s) => s ? t : Duration.zero)
      .scan<Duration>((a, c, _) => a - c > Duration.zero ? a - c : Duration.zero, Values.seconds);

  @override
  void initState() {
    super.initState();
    unawaited(context.controller.onInit(_cameraController, _cameraImageSubject));

    _subscriptions.addAll([
      _durationStream.takeWhileInclusive((x) => x > Duration.zero).listen(_durationSubject.add),
      _cameraImageSubject
          .where((_) => _cameraController.value.isInitialized && _cameraController.value.isStreamingImages)
          .exhaustMap(_onExhaustMapCameraImage)
          .map(_onMapCameraImage)
          .listen(_onListenCameraImage),
      _durationSubject.where((x) => x == Duration.zero).throttleTime(Values.seconds).delay(Values.seconds * 2).listen(_onListenDurationZero),
    ]);
  }

  Stream<(Iterable<Face>, int)> _onExhaustMapCameraImage(CameraImage cameraImage) {
    final list = cameraImage.planes.map((y) => y.bytes).fold<BytesBuilder>(BytesBuilder(), (a, c) => a..add(c)).toBytes();
    final bytes = (WriteBuffer()..putUint8List(list)).done().buffer.asUint8List();
    final rotation =
        InputImageRotationValue.fromRawValue(context.controller.state.model.cameraDescription.sensorOrientation) ?? InputImageRotation.rotation0deg;
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
        rotation: rotation,
        format: InputImageFormatValue.fromRawValue(cameraImage.format.raw) ?? InputImageFormat.nv21,
        bytesPerRow: (cameraImage.planes.firstOrNull?.bytesPerRow).elvis,
      ),
    );

    // ignore: discarded_futures
    return _faceDetector.processImage(inputImage).asStream().map((x) {
      final size = Platform.isAndroid && [InputImageRotation.rotation90deg, InputImageRotation.rotation270deg].contains(rotation)
          ? cameraImage.width
          : cameraImage.height;

      return (x, size);
    });
  }

  Iterable<Face> _onMapCameraImage((Iterable<Face>, int) pair) {
    final renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
    final renderSize = renderBox?.size ?? Size.zero;
    final renderOffset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    return pair.$1.where((x) {
      final topCenter = x.boundingBox.topCenter.dy * MediaQuery.of(context).size.height / pair.$2;
      final bottomCenter = x.boundingBox.bottomCenter.dy * MediaQuery.of(context).size.height / pair.$2;

      return renderOffset.dy + renderSize.height >= max(topCenter, bottomCenter) && renderOffset.dy <= min(topCenter, bottomCenter);
    });
  }

  void _onListenCameraImage(Iterable<Face> faces) {
    _isFaceDetectedSubject.add(false);

    final headEulerAngleX = faces.firstOrNull?.headEulerAngleX;
    final headEulerAngleY = faces.firstOrNull?.headEulerAngleY;
    final headEulerAngleZ = faces.firstOrNull?.headEulerAngleZ;
    final upperLipTop = faces.firstOrNull?.contours[FaceContourType.upperLipTop];
    final lowerLipBottom = faces.firstOrNull?.contours[FaceContourType.lowerLipBottom];
    final state = (() {
      if (faces.length > 1) {
        return CameraErrorState.empty().copyWith(
          model: context.controller.state.model,
          error: '한 명만 사용할 수 있어요',
        );
      } else if (headEulerAngleX is double &&
          headEulerAngleY is double &&
          headEulerAngleZ is double &&
          upperLipTop is FaceContour &&
          lowerLipBottom is FaceContour) {
        if (headEulerAngleX < 15 && headEulerAngleX > -15 && headEulerAngleY < 15 && headEulerAngleY > -15) {
          _isFaceDetectedSubject.add(true);
          return CameraState.empty().copyWith(
            model: context.controller.state.model,
          );
        } else {
          return CameraErrorState.empty().copyWith(
            model: context.controller.state.model,
            error: '정면을 응시해 주세요',
          );
        }
      } else {
        return CameraErrorState.empty().copyWith(
          model: context.controller.state.model,
          error: '얼굴을 프레임에 맞춰주세요',
        );
      }
    })();

    context.controller.bloc.add(
      InitialEvent(
        state: state,
      ),
    );
  }

  void _onListenDurationZero([Duration? duration]) {
    context.controller.pop(true);
  }

  @override
  void dispose() {
    if (_cameraController.value.isInitialized) {
      unawaited(_cameraController.stopImageStream());
    }

    unawaited(
      Future.wait([
        SystemChrome.setPreferredOrientations(DeviceOrientation.values),
        _cameraController.dispose(),
        _faceDetector.close(),
        ...[_cameraImageSubject].map((x) => x.close()),
        ...[_isFaceDetectedSubject].map((x) => x.close()),
        ..._subscriptions.map((x) => x.cancel()),
      ]),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[CameraView] build: ${context.controller.state}');
    return Stack(
      children: [
        Positioned.fill(
          child: BlocSelector<CameraBloc, CameraState, CameraStatus>(
            selector: (state) => state.model.cameraStatus,
            builder: (context, state) => CameraPreview(_cameraController),
          ),
        ),
        BlocSelector<CameraBloc, CameraState, String?>(
          selector: (state) => state is CameraErrorState ? state.error : null,
          builder: (context, error) {
            final backgroundColor = (error.isset ? Resource.color5C1818 : Colors.black).withOpacity(1 / 2);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ColoredBox(color: backgroundColor),
                      ),
                      ColoredBox(
                        color: backgroundColor,
                        child: const Align(
                          alignment: Alignment.topCenter,
                          child: CloseButton(),
                        ),
                      ),
                    ],
                  ),
                ),
                ColoredBox(
                  color: backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Resource.color222222.withOpacity(3 / 5),
                            borderRadius: const BorderRadius.all(Radius.circular(Values.radiusCircleValue)),
                          ),
                          child: Padding(
                            padding: Paddings.paddingHorizontal16.copyWith(
                              top: Paddings.paddingValue8,
                              bottom: Paddings.paddingValue8,
                            ),
                            child: Text(
                              error ?? '출석을 진행하고 있습니다',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Paddings.height16,
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ColoredBox(
                          color: backgroundColor,
                          child: Paddings.width16,
                        ),
                      ),
                      Center(
                        child: AspectRatio(
                          key: globalKey,
                          aspectRatio: 1,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: Paddings.paddingAll16,
                                  child: SvgPicture.asset('assets/image/guide_line.svg'),
                                ),
                              ),
                              Center(
                                child: StreamBuilder<Duration>(
                                  stream: _durationSubject.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == Duration.zero) {
                                      return const Icon(
                                        Icons.check,
                                        color: Resource.colorPrimary,
                                        size: 120,
                                      );
                                    }

                                    return Text(
                                      (snapshot.data.elvis.inMilliseconds / 1000).toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(1 / 2),
                                        fontSize: 80,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ...const [
                                Alignment.topLeft,
                                Alignment.topRight,
                                Alignment.bottomLeft,
                                Alignment.bottomRight,
                              ].map(
                                (align) => Align(
                                  alignment: align,
                                  child: StreamBuilder<Duration>(
                                    stream: _durationSubject.stream,
                                    builder: (context, snapshot) {
                                      final color = snapshot.data.elvis == Duration.zero
                                          ? Resource.colorPrimary
                                          : error.isset
                                              ? Resource.colorFB2330
                                              : Resource.color13BEC8;
                                      final borderSide = BorderSide(color: color, width: 8);

                                      return DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border(
                                            top: align.y == -1 ? borderSide : BorderSide.none,
                                            right: align.x == 1 ? borderSide : BorderSide.none,
                                            bottom: align.y == 1 ? borderSide : BorderSide.none,
                                            left: align.x == -1 ? borderSide : BorderSide.none,
                                          ),
                                        ),
                                        child: const SizedBox.square(dimension: 40),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).maxWidth(),
                      Expanded(
                        child: ColoredBox(
                          color: backgroundColor,
                          child: Paddings.width16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(color: backgroundColor),
                ),
                StreamBuilder<Duration>(
                  stream: _durationSubject.stream,
                  builder: (context, snapshot) => FilledButtonTheme(
                    data: FilledButtonThemeData(
                      style: FilledButton.styleFrom(
                        backgroundColor: Resource.colorPrimary,
                        disabledBackgroundColor: Resource.colorF7F7F7,
                        disabledForegroundColor: Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(),
                        padding: Paddings.paddingVertical16,
                      ).merge(Theme.of(context).filledButtonTheme.style),
                    ),
                    child: FilledButton(
                      onPressed: snapshot.data == Duration.zero ? _onListenDurationZero : null,
                      child: Text(
                        '완료',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ),
                Paddings.height8,
              ],
            );
          },
        ),
      ],
    );
  }
}
