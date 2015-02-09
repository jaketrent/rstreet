require "json"

module Rstreet
  # TODO: name something more general to manifests (does more than builds)
  class ManifestBuilder
    attr_reader :manifest

    def initialize(manifest_file)
      @manifest = {}
      @manifest_file = manifest_file
    end

    def self.empty_manifest
      {}
    end

    def read
      gz = Zlib::GzipReader.new(@manifest_file)
      @manifest = JSON.parse(gz.read).to_h
      gz.close
      @manifest
    end

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

    def diff(other_manifest)
      # TODO: determine if this is the diff algorithm we want
      # TODO: in the future, account for deletions and delete objects from bucket
      # 8 [ruby-2.1.5]::rstreet]>a.to_set
      # => #<Set: {[:a, 1], [:b, 2], [:c, 3]}>
      #     9 [ruby-2.1.5]::rstreet]>a.to_set.difference b.to_set
      # => #<Set: {[:b, 2], [:c, 3]}>
      #     10 [ruby-2.1.5]::rstreet]>b.to_set.difference a.to_set
      # => #<Set: {[:b, 4]}>
      @manifest.to_set.difference(other_manifest.to_set).to_h.keys
    end
  end
end