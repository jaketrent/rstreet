require 'set'

module Rstreet
  class FilesReader
    def self.read_all(dir)
      dir = File.realpath dir
      # TODO: print if verbose
      # puts "Found files in #{@dir}:"

      files = Dir.glob("#{dir}/**/*").to_set
      dirs = Dir.glob("#{dir}/**/*/").map { |d| d[0..-2] }.to_set

      # puts files.inspect
      # puts ""
      # puts dirs.inspect

      files.subtract(dirs).to_a
    end
  end
end