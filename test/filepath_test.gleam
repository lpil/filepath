import filepath
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

@external(erlang, "filepath_ffi", "is_windows")
@external(javascript, "./filepath_ffi.mjs", "is_windows")
fn is_windows() -> Bool


fn windows_only(f: fn() -> Nil) -> Nil {
  case is_windows() {
    True -> f()
    False -> Nil
  }
}

// Generic test helper
fn test_cases(cases: List(#(a, b)), f: fn(a) -> b) {
  cases
  |> list.each(fn(test_case) {
    let #(input, expected) = test_case
    
    f(input)
    |> should.equal(expected)
  })
}

pub fn split_test() {
  test_cases(
    [
      #("", []),
      #("file", ["file"]),
      #("/usr/local/bin", ["/", "usr", "local", "bin"]),
    ],
    filepath.split,
  )
}

pub fn split_windows_test() {
  use <- windows_only
  test_cases(
    [
      #("C:\\one\\two", ["c:/", "one", "two"]),
      #("C:/one/two", ["c:/", "one", "two"]),
      #("::\\one\\two", ["::", "one", "two"]),
      #("::/one/two", ["::", "one", "two"]),
    ],
    filepath.split_windows,
  )
}

pub fn split_unix_test() {
  test_cases(
    [
      #("", []),
      #("file", ["file"]),
      #("/usr/local/bin", ["/", "usr", "local", "bin"]),
      #("C:\\one\\two", ["C:\\one\\two"]),
      #("C:/one/two", ["C:", "one", "two"]),
    ],
    filepath.split_unix,
  )
}

pub fn join_test() {
  test_cases(
    [
      #(#("/one", "two"), "/one/two"),
      #(#("~", "one"), "~/one"),
      #(#("", "two"), "two"),
      #(#("two", ""), "two"),
      #(#("", "/two"), "two"),
      #(#("/two", ""), "/two"),
      #(#("one", "/two"), "one/two"),
      #(#("/one", "/two"), "/one/two"),
      #(#("/one", "./two"), "/one/./two"),
      #(#("/one", "/"), "/one"),
      #(#("/one", "/two/three/"), "/one/two/three"),
      #(#("/", "one"), "/one"),
    ],
    fn(pair) {
      let #(a, b) = pair
      filepath.join(a, b)
    },
  )
}

pub fn extension_test() {
  test_cases(
    [
      #("file", Error(Nil)),
      #("file.txt", Ok("txt")),
      #("file.txt.gz", Ok("gz")),
      #("one.two/file.txt.gz", Ok("gz")),
      #("one.two/file", Error(Nil)),
      #(".env", Error(Nil)),
    ],
    filepath.extension,
  )
}

pub fn base_name_test() {
  test_cases(
    [
      #("file", "file"),
      #("file.txt", "file.txt"),
      #("/", ""),
      #("/file", "file"),
      #("/one/two/three.txt", "three.txt"),
    ],
    filepath.base_name,
  )
}

pub fn directory_name_test() {
  test_cases(
    [
      #("file", ""),
      #("/one", "/"),
      #("/one/two", "/one"),
      #("one/two", "one"),
      #("~/one", "~"),
      #("/one/two/three/four", "/one/two/three"),
      #("/one/two/three/four/", "/one/two/three"),
      #("one/two/three/four", "one/two/three"),
    ],
    filepath.directory_name,
  )
}

pub fn is_absolute_test() {
  test_cases(
    [
      #("", False),
      #("file", False),
      #("/usr/local/bin", True),
      #("usr/local/bin", False),
      #("../usr/local/bin", False),
      #("./usr/local/bin", False),
      #("/", True),
    ],
    filepath.is_absolute,
  )
}

pub fn expand_test() {
  test_cases(
    [
      #("one", Ok("one")),
      #("/one", Ok("/one")),
      #("/..", Error(Nil)),
      #("/one/two/..", Ok("/one")),
      #("/one/two/../..", Ok("/")),
      #("/one/two/../../..", Error(Nil)),
      #("/one/two/../../three", Ok("/three")),
      #("one", Ok("one")),
      #("..", Error(Nil)),
      #("one/two/..", Ok("one")),
      #("one/two/../..", Ok("")),
      #("one/two/../../..", Error(Nil)),
      #("one/two/../../three", Ok("three")),
      #("/one/.", Ok("/one")),
      #("/one/./two", Ok("/one/two")),
      #("/one/", Ok("/one")),
      #("/one/../", Ok("/")),
    ],
    filepath.expand,
  )
}

pub fn strip_extension_test() {
  test_cases(
    [
      #("src/gleam", "src/gleam"),
      #("src/gleam.toml", "src/gleam"),
      #("package.tar.gz", "package.tar"),
      #("one.two/package", "one.two/package"),
      #(".env", ".env"),
    ],
    filepath.strip_extension,
  )
}
