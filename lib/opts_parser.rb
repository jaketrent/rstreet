require "optparse"
require "ostruct"

module Rstreet
  class OptsParser
    def self.parse(args)
      options = OpenStruct.new
      options.src = args[-1]

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: rstreet [options] <src_dir>"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-e", "--load-env",
                "Load environment from .env file") do |load_env|
          options.load_env = true
        end
        opts.on("-b", "--bucket",
                "S3 destination bucket") do |s3_bucket|
          options.s3_bucket = s3_bucket
        end
        opts.on("-k", "--aws-key",
                "AWS Access Key ID") do |aws_key|
          options.aws_key = aws_key
        end
        opts.on("-s", "--aws-secret",
                "AWS Secret Access Key") do |aws_secret|
          options.aws_secret = aws_secret
        end
        opts.on("-v", "--verbose",
                "Run with expanded messages") do |verbose|
          options.verbose = true
        end
        opts.on("-n", "--dry-run",
                "Run but do not upload") do |dry_run|
          options.dry_run = true
        end

      end

      opt_parser.parse!(args)
      options
    end
  end
end
