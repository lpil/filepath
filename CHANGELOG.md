# Changelog

## v1.1.2 - 2025-04-01

- Fixed a bug with `expand` adding a trailing slash on Windows.

## v1.1.1 - 2025-03-14

- Fixed a bug with `join` not giving correct results when joining to the
  filesystem root.

## v1.1.0 - 2024-11-19

- Updated for `gleam_stdlib` v0.43.0.

## v1.0.0 - 2024-02-08

- All existing functions now support Windows paths when run on Windows.
- The `filepath` module gains the `split_unix` and `split_windows` functions.

## v0.2.0 - 2024-02-08

- The `filepath` module gains the `strip_extension` function.
- Fixed a bug where the `extension` function could return the incorrect value
  for files with no extension in a directory with a `.` in its name.

## v0.1.0 - 2023-11-11

- Initial Release.
