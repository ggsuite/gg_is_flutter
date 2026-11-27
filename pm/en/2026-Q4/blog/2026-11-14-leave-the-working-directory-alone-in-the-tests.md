<!--
@license
Copyright (c) ggsuite

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Leave the working directory alone in the tests

## Motivation

- The working directory belongs to the whole test process. Test files that
  run at the same time all see the same `Directory.current`.
- The tests in `test/is_flutter_test.dart` set `Directory.current` to a
  temp folder and set it back afterwards.
- Other test files of this package read files relative to the working
  directory, `pubspec.yaml` for example.
- When such a test ran while the working directory was the temp folder, it
  failed with a file that was not found. This happened now and then, not
  in every run.
- Nothing was wrong in the test that failed: the cause sat in another test
  file.

## Strategy

- No test changes `Directory.current` any more.
- A test that checks a given folder passes the folder.
- A test that needs another working directory gets it from a zone.
- The code in `lib/` stays as it is. Only the tests changed.

## Pass the directory

- `isFlutterDir(dir)` takes the folder to check as a parameter.
- The tests for it wrote a `pubspec.yaml` into a temp folder, and also
  made that folder the working directory. The second step was never
  needed.
- These tests now create the folder, write the file and call
  `isFlutterDir(tmp)`.

## A zone answers for Directory.current

- The getter `isFlutter` has no parameter. It looks for `pubspec.yaml` in
  `Directory.current`.
- The test »if pubspec.yaml not found« needs a working directory without
  that file.
- It now runs in `IOOverrides.runZoned`, with `getCurrentDirectory`
  returning the temp folder.
- Inside the zone `Directory.current` is the temp folder. Outside, for
  every other test, it is unchanged.
- The `tearDown` that restored the working directory after every test is
  gone: there is nothing left to restore.

## Clean up the temp folders

- Every test that creates a temp folder now deletes it with `addTearDown`.
- Before, these folders stayed behind in the system temp directory.

## Result

- The tests of this package no longer depend on which test file runs next
  to which.
- The package itself is unchanged: `isFlutter` and `isFlutterDir` answer
  as before.

## Open Points

- `isFlutter` still reads `Directory.current`. Code that asks for a given
  folder calls `isFlutterDir(dir)` instead.
- `isFlutter` remembers its first answer. Tests reset it with
  `testResetIsFlutter`.
