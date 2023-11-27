import 'package:face_commute/base/base.dart';

final class ProgramModel extends BaseModel {
  const ProgramModel({
    required this.title,
    required this.code,
    required this.dateTime,
    required this.place,
    required this.latitude,
    required this.longitude,
  });

  factory ProgramModel.empty() => _empty;

  factory ProgramModel.fromJson(json) => json is Map
      ? _empty.copyWith(
          title: json['title'],
          code: json['code'],
          dateTime: json['dateTime'],
          place: json['place'],
          latitude: json['latitude'],
          longitude: json['longitude'],
        )
      : _empty;

  final String title;
  final String code;
  final DateTime dateTime;
  final String place;
  final double latitude;
  final double longitude;

  static final ProgramModel _empty = ProgramModel(
    title: '',
    code: '',
    dateTime: DateTime.now(),
    place: '',
    latitude: 0,
    longitude: 0,
  );

  static final ProgramModel _dummy1 = _empty.copyWith(
    title: '작업설계및분석',
    code: 'B096-1',
    dateTime: DateTime(2023, 12, 11, 19),
    place: '팔달관 307호',
    latitude: 37.2843970144932,
    longitude: 127.04437833183417,
  );

  static final ProgramModel _dummy2 = _empty.copyWith(
    title: '시스템최적화',
    code: 'B101-1',
    dateTime: DateTime(2023, 12, 5, 19),
    place: '에너지센터 507호',
    latitude: 37.282416168836114,
    longitude: 127.04263707465824,
  );

  static final ProgramModel _dummy3 = _empty.copyWith(
    title: '확률과통계입문',
    code: 'B094-1',
    dateTime: DateTime(2023, 12, 6, 19, 30),
    place: '팔달관 307호',
    latitude: 37.2844970144932,
    longitude: 127.04437833183417,
  );

  static final ProgramModel _dummy4 = _empty.copyWith(
    title: '스마트생산개론',
    code: 'B102-1',
    dateTime: DateTime(2023, 11, 30, 19),
    place: '팔달관 409호',
    latitude: 37.2843970144932,
    longitude: 127.04467833183417,
  );

  static final ProgramModel _dummy5 = _empty.copyWith(
    title: '자료구조및알고리즘',
    code: 'B097-1',
    dateTime: DateTime(2023, 12, 8, 19, 15),
    place: '성호관 201호',
    latitude: 37.28279777525213,
    longitude: 127.04525176307054,
  );

  static final ProgramModel _dummy6 = _empty.copyWith(
    title: '컴퓨터시스템입문',
    code: 'B006-1',
    dateTime: DateTime(2023, 12, 9, 10),
    place: '팔달관 1025호',
    latitude: 37.2842970144932,
    longitude: 127.04437833183417,
  );

  static Iterable<ProgramModel> dummys() => [
        _dummy1,
        _dummy2,
        _dummy3,
        _dummy4,
        _dummy5,
        _dummy6,
      ];

  @override
  bool get isEmpty => this == _empty;

  @override
  ProgramModel copyWith({
    String? title,
    String? code,
    DateTime? dateTime,
    String? place,
    double? latitude,
    double? longitude,
  }) =>
      ProgramModel(
        title: title ?? this.title,
        code: code ?? this.code,
        dateTime: dateTime ?? this.dateTime,
        place: place ?? this.place,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  @override
  List<Object?> get props => [title, code, dateTime, place, latitude, longitude];

  @override
  String toString() => 'title: $title code: $code dateTime: $dateTime place: $place latitude: $latitude longitude: $longitude';
}
