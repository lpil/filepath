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

pub fn split_3_test() {
  use <- windows_only
  filepath.split("C:\\one\\two")
  |> should.equal(["c:/", "one", "two"])
}

pub fn split_4_test() {
  use <- windows_only
  filepath.split("C:/one/two")
  |> should.equal(["c:/", "one", "two"])
}

pub fn split_unix_0_test() {
  filepath.split_unix("")
  |> should.equal([])
}

pub fn split_unix_1_test() {
  filepath.split_unix("file")
  |> should.equal(["file"])
}

pub fn split_unix_2_test() {
  filepath.split_unix("/usr/local/bin")
  |> should.equal(["/", "usr", "local", "bin"])
}

pub fn split_unix_3_test() {
  filepath.split_unix("C:\\one\\two")
  |> should.equal(["C:\\one\\two"])
}

pub fn split_unix_4_test() {
  filepath.split_unix("C:/one/two")
  |> should.equal(["C:", "one", "two"])
}

pub fn split_windows_0_test() {
  filepath.split_windows("")
  |> should.equal([])
}

pub fn split_windows_1_test() {
  filepath.split_windows("file")
  |> should.equal(["file"])
}

pub fn split_windows_2_test() {
  filepath.split_windows("/usr/local/bin")
  |> should.equal(["/", "usr", "local", "bin"])
}

pub fn split_windows_3_test() {
  filepath.split_windows("C:\\one\\two")
  |> should.equal(["c:/", "one", "two"])
}

pub fn split_windows_4_test() {
  filepath.split_windows("C:/one/two")
  |> should.equal(["c:/", "one", "two"])
}

pub fn split_windows_5_test() {
  filepath.split_windows("::\\one\\two")
  |> should.equal(["::", "one", "two"])
}

pub fn split_windows_6_test() {
  filepath.split_windows("::/one/two")
  |> should.equal(["::", "one", "two"])
}

pub fn split_windows_drive_prefix_0_test() {
  filepath.split_windows_volume_prefix("/")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_0_inverted_test() {
  filepath.split_windows_volume_prefix("\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_1_test() {
  filepath.split_windows_volume_prefix("/usr/local/bin")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_1_inverted_test() {
  filepath.split_windows_volume_prefix("\\usr\\local\\bin")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_2_test() {
  filepath.split_windows_volume_prefix("")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_3_test() {
  filepath.split_windows_volume_prefix("/")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_3_inverted_test() {
  filepath.split_windows_volume_prefix("\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_4_test() {
  filepath.split_windows_volume_prefix("file")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_5_test() {
  filepath.split_windows_volume_prefix("dir1/dir2/file.txt")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_5_inverted_test() {
  filepath.split_windows_volume_prefix("dir1\\dir2\\file.txt")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_6_test() {
  filepath.split_windows_volume_prefix(":/one/two")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_6_inverted_test() {
  filepath.split_windows_volume_prefix(":\\one\\two")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_7_test() {
  filepath.split_windows_volume_prefix("::/one/two")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_7_inverted_test() {
  filepath.split_windows_volume_prefix("::\\one\\two")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_8_test() {
  filepath.split_windows_volume_prefix("./one:/two")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_8_inverted_test() {
  filepath.split_windows_volume_prefix(".\\one:\\two")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_9_test() {
  filepath.split_windows_volume_prefix("one/two:")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_9_inverted_test() {
  filepath.split_windows_volume_prefix("one\\two:")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_10_test() {
  let input = "C:"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_11_test() {
  let input = "c:"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_12_test() {
  let input = "C:/"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:/", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_12_inverted_test() {
  let input = "C:\\"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:\\", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_13_test() {
  let input = "C:/one/two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:/", "one/two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_13_inverted_test() {
  let input = "C:\\one\\two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:\\", "one\\two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_14_test() {
  let input = "c:/one/two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:/", "one/two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_14_inverted_test() {
  let input = "c:\\one\\two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:\\", "one\\two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_15_test() {
  let input = "C:\\one\\two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:\\", "one\\two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_15_inverted_test() {
  let input = "C:/one/two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:/", "one/two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_16_test() {
  let input = "c:\\one\\two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:\\", "one\\two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_16_inverted_test() {
  let input = "c:/one/two"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:/", "one/two")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_17_test() {
  let input = "C:\\one\\two/three"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:\\", "one\\two/three")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_17_inverted_test() {
  let input = "C:/one/two\\three"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:/", "one/two\\three")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_18_test() {
  let input = "c:/one/two\\three"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:/", "one/two\\three")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_18_inverted_test() {
  let input = "c:\\one\\two/three"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("c:\\", "one\\two/three")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_19_test() {
  filepath.split_windows_volume_prefix("/dir1/dir2/file.txt")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_19_inverted_test() {
  filepath.split_windows_volume_prefix("\\dir1\\dir2\\file.txt")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_20_test() {
  filepath.split_windows_volume_prefix("/dir1/dir2\\file.txt")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_20_inverted_test() {
  filepath.split_windows_volume_prefix("\\dir1\\dir2/file.txt")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_21_test() {
  let input = "C:dir1/dir2/file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:", "dir1/dir2/file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_21_inverted_test() {
  let input = "C:dir1\\dir2\\file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:", "dir1\\dir2\\file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_22_test() {
  let input = "C:dir1/dir2\\file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:", "dir1/dir2\\file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_22_inverted_test() {
  let input = "C:dir1\\dir2/file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("C:", "dir1\\dir2/file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_23_test() {
  let input = "HKLM:"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("HKLM:", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_24_test() {
  let input = "HKLM:/"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("HKLM:/", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_24_inverted_test() {
  let input = "HKLM:\\"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("HKLM:\\", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_25_test() {
  let input = "//./pipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//./pipe", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_25_inverted_test() {
  let input = "\\\\.\\pipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\.\\pipe", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_26_test() {
  let input = "//./pipe/"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//./pipe/", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_26_inverted_test() {
  let input = "\\\\.\\pipe\\"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\.\\pipe\\", "")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_27_test() {
  let input = "//./pipe/testpipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//./pipe/", "testpipe")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_27_inverted_test() {
  let input = "\\\\.\\pipe\\testpipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\.\\pipe\\", "testpipe")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_28_test() {
  let input = "HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("HKLM:/", "SOFTWARE/Microsoft/Windows/CurrentVersion")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_28_inverted_test() {
  let input = "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(
    Ok(#("HKLM:\\", "SOFTWARE\\Microsoft\\Windows\\CurrentVersion")),
  )

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_29_test() {
  let input = "//./Volume{b75e2c83-0000-0000-0000-602f00000000}/Test/Foo.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(
    Ok(#("//./Volume{b75e2c83-0000-0000-0000-602f00000000}/", "Test/Foo.txt")),
  )

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_29_inverted_test() {
  let input =
    "\\\\.\\Volume{b75e2c83-0000-0000-0000-602f00000000}\\Test\\Foo.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(
    Ok(#(
      "\\\\.\\Volume{b75e2c83-0000-0000-0000-602f00000000}\\",
      "Test\\Foo.txt",
    )),
  )

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_30_test() {
  let input = "//LOCALHOST/c$/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//LOCALHOST/c$/", "temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_30_inverted_test() {
  let input = "\\\\LOCALHOST\\c$\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\LOCALHOST\\c$\\", "temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_31_test() {
  let input = "//./c:/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//./c:/", "temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_31_inverted_test() {
  let input = "\\\\.\\c:\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\.\\c:\\", "temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_32_test() {
  let input = "//?/c:/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//?/c:/", "temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_32_inverted_test() {
  let input = "\\\\?\\c:\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\?\\c:\\", "temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_33_test() {
  let input = "//./UNC/LOCALHOST/c$/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//./UNC/", "LOCALHOST/c$/temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_33_inverted_test() {
  let input = "\\\\.\\UNC\\LOCALHOST\\c$\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\.\\UNC\\", "LOCALHOST\\c$\\temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_34_test() {
  let input = "//?/UNC/LOCALHOST/c$/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//?/UNC/", "LOCALHOST/c$/temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_34_inverted_test() {
  let input = "\\\\?\\UNC\\LOCALHOST\\c$\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\?\\UNC\\", "LOCALHOST\\c$\\temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_35_test() {
  let input = "//127.0.0.1/c$/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//127.0.0.1/c$/", "temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_35_inverted_test() {
  let input = "\\\\127.0.0.1\\c$\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\127.0.0.1\\c$\\", "temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_36_test() {
  let input = "//DESKTOP-123/MyShare/subdir/file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//DESKTOP-123/MyShare/", "subdir/file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_36_inverted_test() {
  let input = "\\\\DESKTOP-123\\MyShare\\subdir\\file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\DESKTOP-123\\MyShare\\", "subdir\\file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_37_test() {
  filepath.split_windows_volume_prefix("//")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_37_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_38_test() {
  filepath.split_windows_volume_prefix("//.")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_38_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\.")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_39_test() {
  filepath.split_windows_volume_prefix("//./")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_39_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\.\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_40_test() {
  filepath.split_windows_volume_prefix("//?")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_40_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\?")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_41_test() {
  filepath.split_windows_volume_prefix("//?/")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_41_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\?\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_42_test() {
  filepath.split_windows_volume_prefix("//.///")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_42_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\.\\\\\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_43_test() {
  filepath.split_windows_volume_prefix("//?///")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_43_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\?\\\\\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_44_test() {
  filepath.split_windows_volume_prefix("//127.0.0.1")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_44_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\127.0.0.1")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_45_test() {
  filepath.split_windows_volume_prefix("//127.0.0.1/")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_45_inverted_test() {
  filepath.split_windows_volume_prefix("\\\\127.0.0.1\\")
  |> should.equal(Error(Nil))
}

pub fn split_windows_drive_prefix_46_test() {
  let input = "//./////pipe///testpipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//./////pipe/", "//testpipe")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_46_inverted_test() {
  let input = "\\\\.\\\\\\\\\\pipe\\\\\\testpipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\.\\\\\\\\\\pipe\\", "\\\\testpipe")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_47_test() {
  let input = "//?///////pipe///testpipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//?///////pipe/", "//testpipe")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_47_inverted_test() {
  let input = "\\\\?\\\\\\\\\\\\\\pipe\\\\\\testpipe"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\?\\\\\\\\\\\\\\pipe\\", "\\\\testpipe")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_48_test() {
  let input = "//127.0.0.1/////c$/temp/test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("//127.0.0.1/////c$/", "temp/test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
}

pub fn split_windows_drive_prefix_48_inverted_test() {
  let input = "\\\\127.0.0.1\\\\\\\\\\c$\\temp\\test-file.txt"
  filepath.split_windows_volume_prefix(input)
  |> should.equal(Ok(#("\\\\127.0.0.1\\\\\\\\\\c$\\", "temp\\test-file.txt")))

  let assert Ok(#(drive, rest)) = filepath.split_windows_volume_prefix(input)
  should.be_true(drive <> rest == input)
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

pub fn extension_3_test() {
  filepath.extension("one.two/file.txt.gz")
  |> should.equal(Ok("gz"))
}

pub fn extension_4_test() {
  filepath.extension("one.two/file")
  |> should.equal(Error(Nil))
}

pub fn extension_5_test() {
  filepath.extension(".env")
  |> should.equal(Error(Nil))
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

pub fn strip_extension_1_test() {
  filepath.strip_extension("src/gleam")
  |> should.equal("src/gleam")
}

pub fn strip_extension_2_test() {
  filepath.strip_extension("src/gleam.toml")
  |> should.equal("src/gleam")
}

pub fn strip_extension_3_test() {
  filepath.strip_extension("package.tar.gz")
  |> should.equal("package.tar")
}

pub fn strip_extension_4_test() {
  filepath.strip_extension("one.two/package")
  |> should.equal("one.two/package")
}

pub fn strip_extension_5_test() {
  filepath.strip_extension(".env")
  |> should.equal(".env")
}
