import 'dart:async';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

/// A function with one input that's intended to be called in a test context.
typedef Tester<T> = FutureOr<void> Function(T input);
typedef GladosWidgetTester<T> = FutureOr<void> Function(
    WidgetTester tester, T input);
typedef TesterWithRandom<T> = FutureOr<void> Function(T input, Random random);

/// A function with two inputs that's intended to be called in a test context.
typedef Tester2<A, B> = FutureOr<void> Function(A firstInput, B secondInput);
typedef GladosWidgetTester2<A, B> = FutureOr<void> Function(
    WidgetTester tester, A firstInput, B secondInput);
typedef Tester2WithRandom<A, B> = FutureOr<void> Function(
    A firstInput, B secondInput, Random random);

/// A function with three inputs that's intended to be called in a test context.
typedef Tester3<A, B, C> = FutureOr<void> Function(
    A firstInput, B secondInput, C thirdInput);
typedef GladosWidgetTester3<A, B, C> = FutureOr<void> Function(
    WidgetTester tester, A firstInput, B secondInput, C thirdInput);
typedef Tester3WithRandom<A, B, C> = FutureOr<void> Function(
    A firstInput, B secondInput, C thirdInput, Random random);

/// A simple class storing statistics.
class Statistics {
  var exploreCounter = 0;
  var shrinkCounter = 0;
}

extension RandomUtils on Random {
  T choose<T>(List<T> list) => list[nextInt(list.length)];
  int nextIntInRange(int min, int max) {
    assert(min < max);
    return _nextIntUpTo(max - min) + min;
  }

  int _nextIntUpTo(int max) {
    // `Random`'s `nextInt` can only generate numbers up to 2^32. If we want a
    // bigger number, we'll have to first generate the upper bits and then the
    // lower ones.
    if (max < 1 << 32) {
      return nextInt(max);
    } else {
      final upperPart = nextInt(max >> 32);
      final lowerPart = nextInt(1 << 32);
      return (upperPart << 32 + lowerPart) % max;
    }
  }

  Random nextRandom() => Random(nextInt(1234567890));
}

/// Runs the [tester] with the [input]. Catches thrown errors and instead
/// returns a [bool] indicating whether the tester ran through successfully.
FutureOr<bool> succeeds<T>(Tester<T> tester, T input) async {
  try {
    await tester(input);
    return true;
  } catch (e) {
    return false;
  }
}

extension CamelCasing on String {
  String toLowerCamelCase() => this[0].toLowerCase() + substring(1);
}

extension JoinableStrings on List<String> {
  String joinLines() => join('\n');
  String joinParts() => join('\n\n');
}
