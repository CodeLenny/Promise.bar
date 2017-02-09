## Unreleased

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
