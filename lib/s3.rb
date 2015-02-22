require "aws-sdk"

module Rstreet
  class S3
    def initialize(s3_bucket)
      @s3 = AWS::S3.new
      @s3_bucket = s3_bucket
    end

    def get_file(uploadable)
      @s3.buckets[@s3_bucket].objects[uploadable.name].read
    rescue AWS::S3::Errors::NoSuchKey
    end

    def put_file(uploadable)
      @s3.buckets[@s3_bucket].objects[uploadable.name].write(file: uploadable.path, acl: :authenticated_read)
    end
  end
end