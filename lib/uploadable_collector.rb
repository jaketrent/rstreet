require "files_reader"
require "manifest_builder"
require "uploadable"

module Rstreet
  class UploadableCollector

    attr_reader :manifest_uploadable

    def initialize(src)
      @src = File.realpath src
      init_manifest_builder
    end

    def collect
      files = FilesReader.read_all(@src)
      uploadables = convert_files_to_uploadables files
      save_uploadables_in_manifest uploadables
      uploadables
    end

    private

    def save_uploadables_in_manifest(uploadables)
      uploadables.each do |u|
        @manifest_builder.add u
      end
      @manifest_builder.write
    end

    def init_manifest_builder
      manifest_file = File.join(@src, ".manifest.json")
      @manifest_uploadable = convert_to_uploadable(manifest_file)
      @manifest_builder = ManifestBuilder.new manifest_file
    end

    def convert_files_to_uploadables(files)
      files.map do |file|
        convert_to_uploadable(file)
      end
    end

    def add_manifest_to_uploadables(uploadables)
      uploadables << @manifest_uploadable if uploadables.any?
      uploadables
    end

    def convert_to_uploadable(file)
      Uploadable.new(format_uploadable_name(file), file)
    end

    def format_uploadable_name(file)
      file.sub(@src, "")
    end

  end
end