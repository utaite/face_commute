enum Day {
  sun(value: '일'),
  mon(value: '월'),
  tue(value: '화'),
  wed(value: '수'),
  thu(value: '목'),
  fri(value: '금'),
  sat(value: '토');

  const Day({
    required this.value,
  });

  final String value;
}
