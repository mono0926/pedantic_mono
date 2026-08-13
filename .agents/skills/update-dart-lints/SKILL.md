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
   - Read [https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md](https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md) or [https://dart.dev/changelog](https://dart.dev/changelog) thoroughly.
   - Search specifically for the **`Tools -> Linter`** and **`Tools -> Analyzer`** sections of the target release to capture ALL newly added, modified, or deprecated lints.
   - Note:
     - The latest stable Dart version number (e.g., `3.13.0`).
     - ALL new linter rules added in this release.
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

### 2. Rule Impact Evaluation & User Review (MANDATORY)

Do **NOT** automatically enable all newly discovered linter rules without evaluation. You must evaluate each new rule for potential drawbacks and consult the user before editing `lib/analysis_options.yaml`:

1. **Analyze Impact & Drawbacks**:
   - **Experimental Rules**: Identify if a rule is marked as experimental (e.g., `use_primary_constructors`). Experimental rules often introduce excessive noise or unexpected warnings.
   - **Strict Mode Rules**: Identify if a rule duplicates analyzer options (e.g., `no_dynamic_casts` vs `strict-casts: true`) or creates excessive friction in day-to-day coding.
   - **Style & DX Impact**: Assess if a rule forces rigid code style changes (e.g., `empty_container_bodies`, `use_declaring_parameters`) or creates friction with interface implementations (e.g., `async_return_with_no_await`).

2. **Present Table & Consult User**:
   - Present a clear evaluation table for the user showing each candidate rule, its purpose, impact level (High / Medium / Low / Experimental), and potential drawbacks.
   - Ask the user which rules to enable, omit, or keep commented out.
   - **Wait for explicit user approval** on the selected set of rules before updating `lib/analysis_options.yaml`.

### 3. Update Configurations & Code

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

### 4. Update `CHANGELOG.md`

Add a new version entry at the top of `CHANGELOG.md` following `pedantic_mono`'s conventions:

- Use a minor version bump for new Dart version support / added lints (e.g., `## 1.38.0`).
- Format entries as follows (always include links to `https://dart.dev/tools/linter-rules/<lint_name>` for linter rules):
  ```markdown
  ## 1.38.0

  - Change minimum Dart version to ^3.13 🎯
  - Add [`initialize_in_field_declaration`](https://dart.dev/tools/linter-rules/initialize_in_field_declaration)
  - Remove deprecated lints
    - [`avoid_private_typedef_functions`](https://dart.dev/tools/linter-rules/avoid_private_typedef_functions)
    - [`one_member_abstracts`](https://dart.dev/tools/linter-rules/one_member_abstracts)
    - [`unnecessary_await_in_return`](https://dart.dev/tools/linter-rules/unnecessary_await_in_return)
  ```

### 5. Trigger Release Workflow (`release-pub`)

Once changes and `CHANGELOG.md` are prepared and verified:

1. Trigger the `release-pub` skill workflow to handle release publishing.
2. Ensure pre-release dry-run passes:
   ```bash
   dart pub publish --dry-run
   ```
3. Request confirmation from the user before tagging and committing.
4. Execute release git operations and GitHub release creation as defined in `release-pub`.
