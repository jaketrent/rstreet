require "s3"
require "pp"

module Rstreet
  class BucketCommunicator
    def initialize(s3_bucket)
      @s3 = S3.new(s3_bucket)
    end

    def pull_manifest(manfiest_uploadable)
      res = @s3.get_file(manfiest_uploadable)
      puts "read manifest", res.inspect
      # TODO: read and unzip ....

      res.instance_variables.map do |var|
        puts [var, res.instance_variable_get(var)].join(":")
      end
    end
  end
end