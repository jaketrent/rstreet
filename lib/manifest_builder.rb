require "json"

module Rstreet
  class ManifestBuilder
    def initialize(manifest_file)
      @manifest = {}
      @manifest_file = manifest_file
    end

    # TODO: impl read() here?

    def write()
      File.open(@manifest_file, "w") do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write @manifest.to_json.to_s
        gz.close
      end
    end

    def add(uploadable)
      @manifest[uploadable.name] = uploadable.hash
    end
  end
end