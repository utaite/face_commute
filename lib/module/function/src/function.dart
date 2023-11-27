import 'dart:math' as math;

int get randomInt => getRandomInt(4294967296);

int getRandomInt(int length) => math.Random().nextInt(length);
