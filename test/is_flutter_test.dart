// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:gg_is_flutter/src/is_flutter.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  setUp(testResetIsFlutter);

  // No test changes Directory.current: the working directory belongs to the
  // whole test process, and test files running at the same time read files
  // relative to it. A zone answers for it instead where a test needs
  // another one.

  group('IsFlutter', () {
    test('should work fine', () {
      // const IsFlutter();
      expect(isFlutter, isFalse);
    });

    group('should throw', () {
      test('if pubspec.yaml not found', () {
        final tmp = Directory.systemTemp.createTempSync();
        addTearDown(() => tmp.deleteSync(recursive: true));

        IOOverrides.runZoned(() {
          expect(
            () => isFlutter,
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'toString',
                'Exception: pubspec.yaml not found',
              ),
            ),
          );
        }, getCurrentDirectory: () => tmp);
      });
    });

    group('isFlutterDir(dir)', () {
      group('should return true', () {
        test('if directory is a flutter project', () {
          final tmp = Directory.systemTemp.createTempSync();
          addTearDown(() => tmp.deleteSync(recursive: true));
          final pubspec = File(join(tmp.path, 'pubspec.yaml'));
          pubspec.writeAsStringSync('''
name: test
description: A new Flutter project.
version: 1.0.0+1
   flutter:
environment:
  sdk: flutter
''');
          expect(isFlutterDir(tmp), isTrue);
        });
      });

      group('should return false', () {
        test('if directory is not a flutter project', () {
          final tmp = Directory.systemTemp.createTempSync();
          addTearDown(() => tmp.deleteSync(recursive: true));
          final pubspec = File(join(tmp.path, 'pubspec.yaml'));
          pubspec.writeAsStringSync('''
name: test
description: A new Flutter project.
version: 1.0.0+1
''');
          expect(isFlutterDir(tmp), isFalse);
        });
      });
    });
  });
}
