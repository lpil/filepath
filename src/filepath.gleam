// References:
// https://github.com/erlang/otp/blob/master/lib/stdlib/src/filename.erl
// https://github.com/elixir-lang/elixir/blob/main/lib/elixir/lib/path.ex
// https://github.com/elixir-lang/elixir/blob/main/lib/elixir/test/elixir/path_test.exs
// https://cs.opensource.google/go/go/+/refs/tags/go1.21.4:src/path/match.go

import gleam/list
import gleam/bool
import gleam/string
import gleam/result

@external(erlang, "filepath_ffi", "is_windows")
@external(javascript, "./filepath_ffi.mjs", "is_windows")
fn is_windows() -> Bool

// TODO: document
pub fn join(left: String, right: String) -> String {
  case left, right {
    _, "/" -> left
    "", _ -> relative(right)
    "/", _ -> right
    _, _ ->
      remove_trailing_slash(left)
      |> string.append("/")
      |> string.append(relative(right))
  }
  |> remove_trailing_slash
}

// TODO: document
// TODO: windows support
pub fn relative(path: String) -> String {
  case path {
    "/" <> path -> relative(path)
    _ -> path
  }
}

fn remove_trailing_slash(path: String) -> String {
  case string.ends_with(path, "/") {
    True -> string.drop_right(path, 1)
    False -> path
  }
}

// TODO: document
// TODO: Windows support
pub fn split(path: String) -> List(String) {
  case is_windows() {
    True -> split_windows(path)
    False -> split_unix(path)
  }
}

fn split_unix(path: String) -> List(String) {
  case string.split(path, "/") {
    [""] -> []
    ["", ..rest] -> ["/", ..rest]
    rest -> rest
  }
  |> list.filter(fn(x) { x != "" })
}

// TODO: implement it!
fn split_windows(path: String) -> List(String) {
  split_unix(path)
}

// TODO: document
pub fn extension(path: String) -> Result(String, Nil) {
  case string.split(path, ".") {
    [_, extension] -> Ok(extension)
    [_, ..rest] -> list.last(rest)
    _ -> Error(Nil)
  }
}

// TODO: document
// TODO: windows support
pub fn base_name(path: String) -> String {
  use <- bool.guard(when: path == "/", return: "")

  path
  |> split
  |> list.last
  |> result.unwrap("")
}

// TODO: document
// TODO: windows support
pub fn directory_name(path: String) -> String {
  let path = remove_trailing_slash(path)
  case path {
    "/" <> rest -> get_directory_name(string.to_graphemes(rest), "/", "")
    _ -> get_directory_name(string.to_graphemes(path), "", "")
  }
}

fn get_directory_name(
  path: List(String),
  acc: String,
  segment: String,
) -> String {
  case path {
    ["/", ..rest] -> get_directory_name(rest, acc <> segment, "/")
    [first, ..rest] -> get_directory_name(rest, acc, segment <> first)
    [] -> acc
  }
}

// TODO: document
// TODO: windows support
pub fn is_absolute(path: String) -> Bool {
  string.starts_with(path, "/")
}

// TODO: document
// TODO: windows support
pub fn expand(path: String) -> Result(String, Nil) {
  let is_absolute = is_absolute(path)
  let result =
    path
    |> split
    |> root_slash_to_empty
    |> expand_segments([])

  case is_absolute && result == Ok("") {
    True -> Ok("/")
    False -> result
  }
}

fn expand_segments(
  path: List(String),
  base: List(String),
) -> Result(String, Nil) {
  case base, path {
    // Going up past the root (empty string in this representation)
    [""], ["..", ..] -> Error(Nil)

    // Going up past the top of a relative path
    [], ["..", ..] -> Error(Nil)

    // Going up successfully
    [_, ..base], ["..", ..path] -> expand_segments(path, base)

    // Discarding `.`
    _, [".", ..path] -> expand_segments(path, base)

    // Adding a segment
    _, [s, ..path] -> expand_segments(path, [s, ..base])

    // Done!
    _, [] -> Ok(string.join(list.reverse(base), "/"))
  }
}

fn root_slash_to_empty(segments: List(String)) -> List(String) {
  case segments {
    ["/", ..rest] -> ["", ..rest]
    _ -> segments
  }
}
