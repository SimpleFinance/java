# This is a wrapper around the Rubygems TarReader and Zlib
# http://dracoater.blogspot.com/2013/10/extracting-files-from-targz-with-ruby.html

require 'rubygems/package'
require 'zlib'

module ChefJava
  module Helpers
    class Tar

      def initialize(archive, destination)
        @archive = archive
        @destination = destination
      end

      TAR_LONGLINK = '././@LongLink'

      # TODO: Clean me.
      # I don't think we need all these rm_rf calls.
      def write_file(dest, entry)
        if entry.directory?
          FileUtils.rm_rf dest unless File.directory? dest
          FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
        elsif entry.file?
          FileUtils.rm_rf dest unless File.file? dest
          # write only - binary mode
          File.open dest, 'wb' do |f|
            f.print entry.read
          end
          FileUtils.chmod entry.header.mode, dest, :verbose => false
        elsif entry.header.typeflag == '2' #Symlink!
          File.symlink entry.header.linkname, dest
        end
      end

      def longlink?(entry)
       entry.full_name == TAR_LONGLINK
      end

      def gzip_reader(archive)
        Zlib::GzipReader.open(archive)
      end

      def tar_reader(archive)
        Gem::Package::TarReader.new(archive)
      end

      def longlink(destination, entry)
        File.join(destination, entry.read.strip)
      end

      def link(destination, entry)
        File.join(destination, entry.full_name)
      end

      def get_destination(entry)
        if longlink?(entry)
          longlink(@destination, entry)
        else
          link(@destination, entry)
        end
      end

      def extract_tar
        tar_reader(gzip_reader(@archive)) do |tar|
          tar.each do |entry|
            write_file(get_destination(entry), entry)
          end
        end
      end

    end
  end
end