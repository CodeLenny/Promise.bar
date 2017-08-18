## Unreleased

## 0.1.5 - 2017-08-18

### Modified

- `strip-ansi` was wrongly listed as a `devDependency` instead of a `dependency`.  This has been fixed. (#3)

## 0.1.4 - 2017-02-16

### Added

- `PromiseBar.end()` stops Promise.bar from intercepting all `stdout` messages.

## 0.1.3 - 2017-02-10

Improved documentation, updated out of date resource.

## 0.1.2 - 2017-02-09

Added features: Progress bars can nest.  Labels and progress bars can be colored.
Labels are padded to be equal length.

### Added

- Progress Bar Hierarchy/Indentation
  - `PromiseBar.all` stores a reference to the related `Progress` in the returned Promise
  - `Progress` finds progress-bar children on initialization
  - `Progress#indent` returns the indentation that should proceed the progress bar
  - `Progress#draw` draws descendants
- Color Formatting
  - ANSI codes are ignored when calculating bar length, so `label` and other fields can have color codes
  - Added `barFormat` option, which can transform the bar (add color, etc.)
- Optionally pads labels to make labels an equal length.
- Documentation published to `gh-pages`.

## 0.1.1 - 2017-02-08

Added omitted files.

### Added

- Build system
- `.npmignore` file

## 0.1.0 - 2017-02-08

First release.

### Added

- Progress bars
- Stuck progress bars under `stdout` messages
