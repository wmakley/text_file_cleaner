# encoding utf-8
# frozen_string_literal: true
require "text_file_cleaner/version"
require "text_file_cleaner/cleaning_error"
require "open3"
require "fileutils"

class TextFileCleaner
  attr_accessor :in_file, :out_file, :verbose, :logger

  def initialize(in_file, out_file, verbose: false, logger: nil)
    raise ArgumentError, "in_file and out_file must not be the same" if in_file.to_s == out_file.to_s
    @in_file = in_file
    @out_file = out_file
    @verbose = verbose
    @logger = logger
  end

  def strip_non_utf8_characters
    iconv(from_code: "utf-8", to_code: "utf-8", strip_unknown: true)
  end

  def convert_latin1_to_utf8
    iconv(from_code: "iso-8859-1", to_code: "utf-8")
  end

  # Run iconv in a sub-process, writing results to #out_file
  def iconv(from_code:, to_code:, strip_unknown: false)
    msg = "Converting '#{in_file}' from: '#{from_code}' to: '#{to_code}', strip unknown: #{strip_unknown}"
    log msg

    File.open(out_file, "w") do |out|
      Open3.popen3(ENV,
                   "iconv",
                   "-f", from_code,
                   "-t", "#{to_code}#{strip_unknown ? '//IGNORE' : ''}",
                   in_file
      ) do |stdin, stdout, stderr, wait_thr|
        while (str = stdout.gets)
          out.write(str)
        end

        exit_status = wait_thr.value

        if exit_status != 0
          error_msg = stderr.read
          FileUtils.rm(out_file) if File.file?(out_file)
          raise CleaningError, error_msg
        end
      end
    end

    return out_file
  end

  private

    def log(msg)
      puts msg if verbose
      logger.info msg if logger
    end
end
