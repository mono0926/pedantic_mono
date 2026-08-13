---
name: update-dart-lints
description: Update Dart/Flutter lints to the latest Dart version, adjust lib/analysis_options.yaml, update CHANGELOG.md, and release the package using the release-pub skill. Use when a new Dart/Flutter version is released or when requested to update lints and publish a release.
---

# `update-dart-lints` Skill

This skill automates the process of updating `pedantic_mono` to support the latest Dart/Flutter release, updating linter rules in `lib/analysis_options.yaml`, logging updates in `CHANGELOG.md`, and triggering the `release-pub` skill to publish a new release.

## Reference Links

- **Dart Changelog**: [https://dart.dev/changelog](https://dart.dev/changelog)
- **Dart SDK GitHub Changelog**: [https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md)

---

## Workflow Steps

Follow these steps sequentially to perform a lint update and release:

### 1. Information Gathering & Diff Analysis

1. **Check Official Changelogs**:
   - Inspect [https://dart.dev/changelog](https://dart.dev/changelog) or [https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md) to discover:
     - The latest stable Dart version number (e.g., `3.13.0`).
     - New linter rules added in this release.
     - Deprecated or removed linter rules.

2. **Run Linter Diff Tool**:
   - Run the local grinder task to check diffs and duplicate rules against `flutter_lints`, `recommended`, and `core`:
     ```bash
     dart run tool/grind.dart diff
     ```
   - Analyze the output to see:
     - Rules unique to `pedantic_mono`.
     - Rules introduced in `flutter_lints`.
     - Duplicated rules between `pedantic_mono` and `flutter_lints`.

### 2. Update Configurations & Code

1. **Update `pubspec.yaml`**:
   - Update `environment.sdk` to the new minimum Dart version (e.g., `^3.13.0`):
     ```yaml
     environment:
       sdk: ^3.13.0
     ```

2. **Update `lib/analysis_options.yaml`**:
   - **Add new lints**: Add new linter rules under `linter.rules` in alphabetical order.
   - **Remove duplicates**: Comment out or remove rules that are already included in `flutter_lints`.
   - **Remove deprecated/deleted lints**: Comment out or remove rules that have been removed or deprecated in the new Dart version.

3. **Verify Code Quality**:
   - Run static analysis:
     ```bash
     dart analyze
     ```
     Ensure all errors, warnings, and info-level lints are resolved.
   - Run tests:
     ```bash
     dart test
     ```
     Ensure all tests pass.

### 3. Update `CHANGELOG.md`

Add a new version entry at the top of `CHANGELOG.md` following `pedantic_mono`'s conventions:

- Use a minor version bump for new Dart version support / added lints (e.g., `## 1.38.0`).
- Format entries as follows:
  ```markdown
  ## 1.38.0

  - Change minimum Dart version to ^3.13 🎯
  - Add `new_lint_rule_name`
  - Remove duplicated lints
  ```

### 4. Trigger Release Workflow (`release-pub`)

Once changes and `CHANGELOG.md` are prepared and verified:

1. Trigger the `release-pub` skill workflow to handle release publishing.
2. Ensure pre-release dry-run passes:
   ```bash
   dart pub publish --dry-run
   ```
3. Request confirmation from the user before tagging and committing.
4. Execute release git operations and GitHub release creation as defined in `release-pub`.
