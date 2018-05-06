require "test_helper"
require "fileutils"

class TextFileCleanerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TextFileCleaner::VERSION
  end

  # Create a path to a file in the test directory
  def file(name)
    File.expand_path("../#{name}", __FILE__)
  end

  def test_converting_latin1_to_utf8
    in_file = file("latin-1.txt")
    out_file = file("utf-8-converted.txt")
    cleaner = TextFileCleaner.new(in_file, out_file)
    cleaner.convert_latin1_to_utf8
    assert File.file?(out_file), "Expected #{out_file} to be created, but it was not"
    refute File.zero?(out_file), "Expected #{out_file} not to be empty"
  end

  def test_stripping_non_utf8_characters
    in_file = file("invalid-utf-8.txt")
    out_file = file("non-utf-8-stripped.txt")
    cleaner = TextFileCleaner.new(in_file, out_file)
    cleaner.strip_non_utf8_characters
    assert File.file?(out_file), "Expected #{out_file} to be created, but it was not"
    refute File.zero?(out_file), "Expected #{out_file} not to be empty"
  end

  def test_it_raises_an_error_if_iconv_fails
    in_file = file("fubar")
    out_file = file("error.txt")
    cleaner = TextFileCleaner.new(in_file, out_file)
    assert_raises(TextFileCleaner::CleaningError) do
      cleaner.strip_non_utf8_characters
    end
  end

  def test_deletes_the_output_if_iconv_fails
    in_file = file("fubar")
    out_file = file("errored.txt")
    cleaner = TextFileCleaner.new(in_file, out_file)
    assert_raises(TextFileCleaner::CleaningError) do
      cleaner.strip_non_utf8_characters
    end
    refute File.file?(out_file)
  end
end
