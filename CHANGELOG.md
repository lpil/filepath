# Changelog

## v0.3.0 - 2024-02-08

- All existing functions now support Windows paths when run on Windows.
- The `filepath` module gains the `split_unix` and `split_windows` functions.

## v0.2.0 - 2024-02-08

- The `filepath` module gains the `strip_extension` function.
- Fixed a bug where the `extension` function could return the incorrect value
  for files with no extension in a directory with a `.` in its name.

## v0.1.0 - 2023-11-11

- Initial Release.
