import filepath
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

@external(erlang, "filepath_ffi", "is_windows")
@external(javascript, "./filepath_ffi.mjs", "is_windows")
fn is_windows() -> Bool

fn windows_only(f: fn() -> whatever) -> Nil {
  case is_windows() {
    True -> {
      f()
      Nil
    }
    False -> Nil
  }
}

pub fn split_0_test() {
  filepath.split("")
  |> should.equal([])
}

pub fn split_1_test() {
  filepath.split("file")
  |> should.equal(["file"])
}

pub fn split_2_test() {
  filepath.split("/usr/local/bin")
  |> should.equal(["/", "usr", "local", "bin"])
}

pub fn split_windows_0_test() {
  use <- windows_only
  filepath.split("C:\\one\\two")
  |> should.equal(["c:/", "one", "two"])
}

pub fn split_windows_1_test() {
  use <- windows_only
  filepath.split("C:/one/two")
  |> should.equal(["c:/", "one", "two"])
}

pub fn join_0_test() {
  filepath.join("/one", "two")
  |> should.equal("/one/two")
}

pub fn join_1_test() {
  filepath.join("~", "one")
  |> should.equal("~/one")
}

pub fn join_2_test() {
  filepath.join("", "two")
  |> should.equal("two")
}

pub fn join_3_test() {
  filepath.join("two", "")
  |> should.equal("two")
}

pub fn join_4_test() {
  filepath.join("", "/two")
  |> should.equal("two")
}

pub fn join_5_test() {
  filepath.join("/two", "")
  |> should.equal("/two")
}

pub fn join_6_test() {
  filepath.join("one", "/two")
  |> should.equal("one/two")
}

pub fn join_7_test() {
  filepath.join("/one", "/two")
  |> should.equal("/one/two")
}

pub fn join_8_test() {
  filepath.join("/one", "/two")
  |> should.equal("/one/two")
}

pub fn join_9_test() {
  filepath.join("/one", "./two")
  |> should.equal("/one/./two")
}

pub fn join_10_test() {
  filepath.join("/one", "/")
  |> should.equal("/one")
}

pub fn join_11_test() {
  filepath.join("/one", "/two/three/")
  |> should.equal("/one/two/three")
}

pub fn extension_0_test() {
  filepath.extension("file")
  |> should.equal(Error(Nil))
}

pub fn extension_1_test() {
  filepath.extension("file.txt")
  |> should.equal(Ok("txt"))
}

pub fn extension_2_test() {
  filepath.extension("file.txt.gz")
  |> should.equal(Ok("gz"))
}

pub fn base_name_0_test() {
  filepath.base_name("file")
  |> should.equal("file")
}

pub fn base_name_1_test() {
  filepath.base_name("file.txt")
  |> should.equal("file.txt")
}

pub fn base_name_2_test() {
  filepath.base_name("/")
  |> should.equal("")
}

pub fn base_name_3_test() {
  filepath.base_name("/file")
  |> should.equal("file")
}

pub fn base_name_4_test() {
  filepath.base_name("/one/two/three.txt")
  |> should.equal("three.txt")
}

pub fn directory_name_0_test() {
  filepath.directory_name("file")
  |> should.equal("")
}

pub fn directory_name_1_test() {
  filepath.directory_name("/one")
  |> should.equal("/")
}

pub fn directory_name_2_test() {
  filepath.directory_name("/one/two")
  |> should.equal("/one")
}

pub fn directory_name_3_test() {
  filepath.directory_name("one/two")
  |> should.equal("one")
}

pub fn directory_name_4_test() {
  filepath.directory_name("~/one")
  |> should.equal("~")
}

pub fn directory_name_5_test() {
  filepath.directory_name("/one/two/three/four")
  |> should.equal("/one/two/three")
}

pub fn directory_name_6_test() {
  filepath.directory_name("/one/two/three/four/")
  |> should.equal("/one/two/three")
}

pub fn directory_name_7_test() {
  filepath.directory_name("one/two/three/four")
  |> should.equal("one/two/three")
}

pub fn is_absolute_0_test() {
  filepath.is_absolute("")
  |> should.equal(False)
}

pub fn is_absolute_1_test() {
  filepath.is_absolute("file")
  |> should.equal(False)
}

pub fn is_absolute_2_test() {
  filepath.is_absolute("/usr/local/bin")
  |> should.equal(True)
}

pub fn is_absolute_3_test() {
  filepath.is_absolute("usr/local/bin")
  |> should.equal(False)
}

pub fn is_absolute_4_test() {
  filepath.is_absolute("../usr/local/bin")
  |> should.equal(False)
}

pub fn is_absolute_5_test() {
  filepath.is_absolute("./usr/local/bin")
  |> should.equal(False)
}

pub fn is_absolute_6_test() {
  filepath.is_absolute("/")
  |> should.equal(True)
}

pub fn expand_0_test() {
  filepath.expand("one")
  |> should.equal(Ok("one"))
}

pub fn expand_1_test() {
  filepath.expand("/one")
  |> should.equal(Ok("/one"))
}

pub fn expand_2_test() {
  filepath.expand("/..")
  |> should.equal(Error(Nil))
}

pub fn expand_3_test() {
  filepath.expand("/one/two/..")
  |> should.equal(Ok("/one"))
}

pub fn expand_4_test() {
  filepath.expand("/one/two/../..")
  |> should.equal(Ok("/"))
}

pub fn expand_5_test() {
  filepath.expand("/one/two/../../..")
  |> should.equal(Error(Nil))
}

pub fn expand_6_test() {
  filepath.expand("/one/two/../../three")
  |> should.equal(Ok("/three"))
}

pub fn expand_7_test() {
  filepath.expand("one")
  |> should.equal(Ok("one"))
}

pub fn expand_8_test() {
  filepath.expand("..")
  |> should.equal(Error(Nil))
}

pub fn expand_9_test() {
  filepath.expand("one/two/..")
  |> should.equal(Ok("one"))
}

pub fn expand_10_test() {
  filepath.expand("one/two/../..")
  |> should.equal(Ok(""))
}

pub fn expand_11_test() {
  filepath.expand("one/two/../../..")
  |> should.equal(Error(Nil))
}

pub fn expand_12_test() {
  filepath.expand("one/two/../../three")
  |> should.equal(Ok("three"))
}

pub fn expand_13_test() {
  filepath.expand("/one/.")
  |> should.equal(Ok("/one"))
}

pub fn expand_14_test() {
  filepath.expand("/one/./two")
  |> should.equal(Ok("/one/two"))
}

pub fn expand_15_test() {
  filepath.expand("/one/")
  |> should.equal(Ok("/one"))
}

pub fn expand_16_test() {
  filepath.expand("/one/../")
  |> should.equal(Ok("/"))
}
