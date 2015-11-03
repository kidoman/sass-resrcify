require "sass"
require "uri"
require "digest/sha1"

module Sass
  module Importers
    class Resrcify
      def initialize
        @processed = {}
      end

      def resrc(asset, file, opts = {})
        dest_dir = opts[:dest] || ""
        prefix = opts[:prefix] || ""

        url = URI.parse(asset)
        return asset if url.scheme

        asset = url.path

        base_dir = File.dirname(file)
        src_file = File.expand_path(asset, base_dir)

        return @processed[src_file] if @processed.key?(src_file)

        begin
          hash = Digest::SHA1.file(src_file).hexdigest[0...16]
        rescue
          return asset
        end

        ext = File.extname(asset)
        orig_name = File.basename(asset, ext)
        name = "#{orig_name}-#{hash}#{ext}"
        dest_file = File.join(dest_dir, name)

        FileUtils.mkdir_p(dest_dir)
        FileUtils.cp(src_file, dest_file)

        @processed[src_file] = File.join(prefix, name)
        @processed[src_file]
      end
    end
  end
end

module Sass
  module Importers
    class Filesystem
      REGEX = /url\([\"\']?([\.a-zA-Z0-9_\-\/@]*?)([\?\#]+.*?)?[\"\']?\)/

      alias old_initialize initialize

      def initialize(root)
        old_initialize(root)
        @resrcify = Resrcify.new
      end

      private

      def _find(dir, name, options)
        full_filename, syntax = Sass::Util.destructure(find_real_file(dir, name, options))
        return unless full_filename && File.readable?(full_filename)

        options[:syntax] = syntax
        options[:filename] = full_filename
        options[:importer] = self

        content = File.read(full_filename)
        content.gsub!(REGEX) do |s|
          asset = @resrcify.resrc($1, full_filename, dest: "static/assets", prefix: "/assets")
          "url('#{asset}#{$2}')"
        end

        Sass::Engine.new(content, options)
      end
    end
  end
end
