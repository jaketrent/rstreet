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
        opts.separator "Options:"

        opts_def.each do |k, v|
          opts.on(v[:short], v[:long], v[:desc]) do |val|
            options[k] = val
          end
        end
      end

      opt_parser.parse!(args)
      options.to_h
    end

    def self.opts_def
      {
        load_env: { short: "-e", long: "--load-env", desc: "Load .env file" },
        s3_bucket: { short: "-b b", long: "--bucket b", desc: "S3 destination bucket" },
        aws_key: { short: "-k k", long: "--aws-key k", desc: "AWS Access Key ID" },
        aws_secret: { short: "-s s", long: "--aws-secret s", desc: "AWS Secret Access Key" },
        verbose: { short: "-v", long: "--verbose", desc: "Run with expanded messages" },
        dry_run: { short: "-d", long: "--dry-run", desc: "Run but do not upload" }
      }
    end

    private_class_method :opts_def
  end
end
