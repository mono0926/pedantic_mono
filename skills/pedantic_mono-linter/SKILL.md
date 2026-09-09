---
name: pedantic_mono-linter
description: >-
  Use when configuring static analysis options, resolving linter warnings or errors,
  or adhering to strict Dart and Flutter code style guidelines enforced by pedantic_mono.
---

# pedantic_mono Static Analysis & Linter Guide

`pedantic_mono` provides an opinionated, highly recommended set of static analysis rules and linter configurations for Dart and Flutter applications, packages, and plugins. It builds on top of `flutter_lints` with stricter code hygiene and modern Dart best practices.

## Guidelines

- **Project Setup**:
  - Always include `pedantic_mono` in `dev_dependencies` of `pubspec.yaml`.
  - In the project root's `analysis_options.yaml`, include the package configuration:
    ```yaml
    include: package:pedantic_mono/analysis_options.yaml
    ```
- **Zero-Tolerance Quality Rule**:
  - Resolve **all** analyzer errors, warnings, and info-level diagnostics before committing or finalizing code changes. A clean static analysis report is mandatory.
- **Automated Fixes**:
  - Run `dart fix --apply` (or `flutter pub run dart fix --apply`) to automatically fix mechanical lint violations before addressing complex manual changes.
- **Key Enforced Conventions**:
  - **Trailing Commas**: Always add a trailing comma on multi-line parameter lists, argument lists, and collection literals.
  - **Async/Await & Futures**: Never leave unawaited `Future`s unhandled. Explicitly `await` them or use `unawaited(...)` from `dart:async` when fire-and-forget is intentional.
  - **Const Constructors**: Prefer `const` constructors whenever possible for immutable objects and widgets.
  - **Explicit Types vs Inferred Types**: Do not specify redundant types on closure parameters or local variables where the type is obvious, but ensure public API declarations have explicit return and parameter types.
  - **Conditionals & Null Safety**: Avoid unnecessary null checks (`!`) or redundant non-null assertions. Leverage pattern matching and switch expressions where applicable.

## Examples

### 1. `analysis_options.yaml` Setup

```yaml
include: package:pedantic_mono/analysis_options.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

# Add custom project-specific overrides only if strictly necessary
# linter:
#   rules:
#     custom_rule: false
```

### 2. Resolving Common Lint Rules

#### Trailing Commas & Const Constructors
```dart
// ❌ Bad: Missing const and missing trailing commas
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: Text('Hello')
  );
}

// ✔️ Good: Properly const and includes trailing commas
Widget build(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('Hello'),
  );
}
```

#### Unawaited Futures
```dart
import 'dart:async';

// ❌ Bad: Unhandled future causes lint warning
void handleClick() {
  analyticsService.logEvent('button_clicked');
}

// ✔️ Good: Explicitly wrapped with unawaited or awaited
void handleClick() {
  unawaited(analyticsService.logEvent('button_clicked'));
}
```

## Common Pitfalls & Anti-Patterns

- ❌ **Anti-pattern**: Disabling linter rules globally in `analysis_options.yaml` to suppress errors quickly.
  - ✔️ **Correct**: Fix the root cause in the code. If an exception must be made for generated files, configure `analyzer.exclude` for those specific generated file patterns (e.g. `**/*.g.dart`, `**/*.freezed.dart`).
- ❌ **Anti-pattern**: Using `// ignore: <rule>` comments across application code without justification.
  - ✔️ **Correct**: Refactor the code to satisfy the linter rule cleanly.
