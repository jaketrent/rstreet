require "aws-sdk"
require "dotenv"

require "bucket_communicator"
require "rstreet/version"
require "uploadable_collector"

module Rstreet
  class Uploader
    def initialize(options)
      @options = options
      load_env if should_load_env?
      config_aws
      validate_options
    end

    def run
      collector = UploadableCollector.new(@options.src)
      uploadables = collector.collect

      bucket_communicator = BucketCommunicator.new(@options.s3_bucket, @options.dry_run)
      old_manifest = bucket_communicator.pull_manifest(collector.manifest_uploadable)
      current_manifest_builder = collector.manifest_builder
      diff = current_manifest_builder.diff(old_manifest)

      to_upload = collector.find_uploadables(diff)
      bucket_communicator.upload(to_upload)
    end

    private

    def config_aws
      AWS.config(access_key_id: @options.aws_key, secret_access_key: @options.aws_secret)
    end

    def load_env
      Dotenv.load
      @options.s3_bucket ||= ENV["S3_BUCKET"]
      @options.aws_key ||= ENV["AWS_ACCESS_KEY_ID"]
      @options.aws_secret ||= ENV["AWS_SECRET_ACCESS_KEY"]
    end

    def should_load_env?
      @options.load_env
    end

    def validate_options
      # TODO: DRY'ify
      raise ArgumentError, "Specify a source directory in options.src" if @options.src.nil?

      raise ArgumentError, "Specify an S3 Bucket in an env var called S3_BUCKET or options.s3_bucket" if @options.s3_bucket.nil?

      raise ArgumentError, "Specify an AWS Access Key Id in an env var called AWS_ACCESS_KEY_ID or options.aws_key" if @options.aws_key.nil?

      raise ArgumentError, "Specify an AWS Secret Access Key in env var called AWS_SECRET_ACCESS_KEY or options.aws_secret" if @options.aws_secret.nil?
    end
  end
end
