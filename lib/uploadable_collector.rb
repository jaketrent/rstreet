require "files_reader"
require "manifest_builder"
require "uploadable"

module Rstreet
  class UploadableCollector

    # TODO: Shouldn't need to get this for the pull_manifest in rstreet.rb
    # Instead, consider some class method with the default file path info
    attr_reader :manifest_builder, :manifest_uploadable

    def initialize(src)
      @src = File.realpath src
      # TODO: get rid of cache and consolidate inside of manifest builder
      @uploadables_cache = {}
      init_manifest_builder
    end

    def collect
      files = FilesReader.read_all(@src)
      uploadables = convert_files_to_uploadables files
      uploadables = add_manifest_to_uploadables uploadables
      save_uploadables_in_manifest uploadables
      uploadables
    end

    # TODO: be more consistent with name, file, path var names
    def find_uploadables(file_names)
      @uploadables_cache.select { |k, v| file_names.include? k }.values
    end

    private

    def save_uploadables_in_manifest(uploadables)
      uploadables.each do |u|
        @manifest_builder.add u
        @uploadables_cache[u.name] = u
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
      file.sub(ensure_ends_with_separator(@src), "")
    end

    def ensure_ends_with_separator(path)
      path.end_with?(File::SEPARATOR) ? path : "#{path}#{File::SEPARATOR}"
    end

  end
end