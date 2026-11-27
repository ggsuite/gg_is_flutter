<!--
@license
Copyright (c) ggsuite

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Migrate to the latest Dart SDK

## Motivation

- gg_is_flutter should build and test on the current Dart SDK 3.14
- The generated DNA files of the repo should match the current DNA, and
  the DNA check placed in the tests should pass the analyzer

## Strategy

- Raise the SDK constraint
- Run `dart migrate --apply` and `dart fix --apply`; both found nothing
  to change
- Regenerate the DNA with `gg dna upgrade`
- Raise the dev dependencies the new DNA check needs

## SDK constraint

- `pubspec.yaml` requires `sdk: ">=3.14.0 <4.0.0"`

## DNA

- `gg dna upgrade` placed `test/dna/dna_test.dart`; on every test run it
  checks that the generated DNA files are unchanged
- The check passes `checkDna` as a tear-off, so `unnecessary_lambdas`
  no longer reports it

## Dependency updates

- `helix` raised to `^1.15.1`: it provides `checkDna` and places the
  check with a tear-off
- `dna_ggsuite` raised to `^2.0.0`; `dna_gg` is no longer a direct
  dependency

## Open Points

- None
