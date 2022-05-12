## 1.19.0

- Change minimum Dart version to '2.17.0'
- Add `used_colored_box`
- Add `use_enums`
- Add `use_super_parameters`

## 1.18.0

- Add `avoid_redundant_argument_values`
## 1.17.0

- Add `require_trailing_commas`

## 1.16.0

- Change minimum Dart version to '2.16.0'
- Add `use_decorated_box`
- Add `no_leading_underscores_for_library_prefixes`
- Add `no_leading_underscores_for_local_identifiers`
- Add `secure_pubspec_urls`
- Add `sized_box_shrink_expand`
- Add `avoid_final_parameters`
- Add `unnecessary_late`

## 1.15.0

- Change minimum Dart version to '2.15.0'
- Add `depend_on_referenced_packages`
- Add `eol_at_end_of_file`
- Add `noop_primitive_operations`
- Add `unnecessary_constructor_name`
- Add `use_test_throws_matchers`

## 1.14.0

- Set analyzer/language/strict-inference to true
- Set analyzer/language/strict-raw-types to true

## 1.13.0

- Depends on `flutter_lints` instead of deprecated `pedantic`

## 1.12.3

- Add `use_key_in_widget_constructors`
- Add `unnecessary_string_interpolations`

## 1.12.2

- Add `avoid_print`

## 1.12.1

- Add `avoid_multiple_declarations_per_line`
- Add `deprecated_consistency`
- Add `use_named_constants`

## 1.12.0-dev

- Add `avoid_dynamic_calls`

## 1.11.0

- Migrated to null safety
- Add new lints
  - avoid_dynamic_calls
  - avoid_type_to_string
  - cast_nullable_to_non_nullable
  - null_check_on_nullable_type_parameter
  - tighten_type_of_initializing_formals
  - unnecessary_null_checks
  - unnecessary_nullable_for_final_variable_declarations
  - use_late

## 1.10.0

- Add `sized_box_for_whitespace`
- Add `exhaustive_cases`
- Add `no_default_cases`
- Add `use_is_even_rather_than_modulo`

## 1.9.1

- Comment out `sized_box_for_whitespace`, which hasn't released to current stable channel (1.17.1)
  - It will be included in 1.10.0-dev for now

## 1.9.0

- Add sized_box_for_whitespace

## 1.8.0

- Disable avoid_types_on_closure_parameters

## 1.7.0

- Add prefer_final_in_for_each

## 1.6.0

- Disable avoid_returning_null_for_future
  - Not work as documented: https://dart-lang.github.io/linter/lints/avoid_returning_null_for_future.html

## 1.5.0

- Update pedantic to 1.9.0

## 1.4.1

- Split out `analysis_options_flutter_samples.yaml`
- It is also valid to specify`include: package:pedantic_mono/analysis_options_flutter_samples.yaml`
  - More loose rules

## 1.4.0

- missing_required_param: warning
- missing_return: warning

## 1.3.0

- Add many linter rules.

## 1.2.0

Add these rules.

- sort_constructors_first
- sort_unnamed_constructors_first

## 1.1.0

Add these rules.

- prefer_const_constructors
- prefer_const_constructors_in_immutables
- prefer_const_declarations
- prefer_const_literals_to_create_immutables

## 1.0.0

- Fix metadata.

## 0.0.1

- First release.
