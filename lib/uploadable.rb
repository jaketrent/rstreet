require "mime/types"

module Rstreet
  class Uploadable
    attr_reader :name, :path, :hash

    def initialize(name, path)
      @name, @path = name, path
      @hash = gen_hash || ""
      @content_type = gen_content_type || "application/octet-stream"
    end

    private

    def gen_hash
      Digest::MD5.file(@path).hexdigest if File.file?(@path)
    end

    def gen_content_type
      MIME::Types.type_for(@path).first.content_type
    rescue
    end
  end
end