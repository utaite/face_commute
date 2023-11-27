import 'package:face_commute/model/model.dart';
import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/main/main_event.dart';
import 'package:face_commute/ui/main/state/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

final class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({
    required MainState initialState,
  }) : super(initialState) {
    on<InitialEvent>(_onInitial);
    on<GetEvent>(_onGet);
  }

  factory MainBloc.empty({MainState? initialState}) => MainBloc(
        initialState: initialState ?? MainState.empty(),
      );

  void _onInitial(InitialEvent event, Emitter<MainState> emit) {
    debugPrint('[MainBloc] _onInitial: $event');
    return emit(event.state ?? MainState.empty());
  }

  Future<void> _onGet(GetEvent event, Emitter<MainState> emit) async {
    debugPrint('[MainBloc] _onGet: $event');
    final labelMarkers = [
      ...ProgramModel.dummys().map(
        (x) => LabelMarker(
          onTap: () => event.onTap(x),
          label: '(${Day.values[x.dateTime.weekday].value}) ${x.title}',
          markerId: MarkerId(randomInt.toString()),
          position: LatLng(x.latitude, x.longitude),
          backgroundColor: Resource.colors[x.title].elvis,
          textStyle: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
    final markers = await Future.wait(labelMarkers.map(toMarker));

    return emit(
      state.copyWith(
        markers: markers.toSet(),
      ),
    );
  }

  Future<Marker> toMarker(LabelMarker labelMarker) async => Marker(
        markerId: labelMarker.markerId,
        position: labelMarker.position,
        icon: await createCustomMarkerBitmap(
          labelMarker.label,
          backgroundColor: labelMarker.backgroundColor,
          textStyle: labelMarker.textStyle,
        ),
        alpha: labelMarker.alpha,
        anchor: labelMarker.anchor,
        consumeTapEvents: labelMarker.consumeTapEvents,
        draggable: labelMarker.draggable,
        flat: labelMarker.flat,
        infoWindow: labelMarker.infoWindow,
        rotation: labelMarker.rotation,
        visible: labelMarker.visible,
        zIndex: labelMarker.zIndex,
        onTap: labelMarker.onTap,
        onDragStart: labelMarker.onDragStart,
        onDrag: labelMarker.onDrag,
        onDragEnd: labelMarker.onDragEnd,
      );
}
