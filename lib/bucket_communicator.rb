require "s3"

require "manifest_builder"

module Rstreet
  class BucketCommunicator
    def initialize(s3_bucket, dry_run)
      @s3, @dry_run = S3.new(s3_bucket), dry_run
    end

    def pull_manifest(manifest_uploadable)
      manifest_file = @s3.get_file(manifest_uploadable)
      if manifest_file
        ManifestBuilder.new(manifest_file).read
      else
        ManifestBuilder.empty_manifest
      end
    end

    def upload(uploadables)
      # TODO: refactor into sep procs
      uploadables.map do |u|
        if dry_run?
          puts "dry run upload: #{u.name}"
        else
          begin
            @s3.put_file(u)
            puts "uploaded:        #{u.name}"
          rescue
            puts "error uploading: #{u.name}"
          end
        end
      end
    end

    private

    def dry_run?
      @dry_run
    end
  end
end