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

      def extract_tar
        tar_reader(gzip_reader(@archive)) do |tar|
          tar.each do |entry|
            write_file(get_destination(entry), entry)
          end
        end
      end

      private

      def write_file(dest, entry)
        if entry.directory?
          tar_mkdir(dest, entry)
        elsif entry.file?
          tar_file(dest, entry)
        elsif entry.header.typeflag == '2' #Symlink!
          tar_symlink(dest, entry)
        end
      end

      def tar_mkdir(tar_dest, tar_entry)
        FileUtils.rm_rf(tar_dest) unless File.directory?(tar_dest)
        FileUtils.mkdir_p(tar_dest, mode: tar_entry.header.mode, verbose: false)
      end

      def tar_file(tar_dest, tar_entry)
        FileUtils.rm_rf(tar_dest) unless File.file?(tar_dest)
        File.open(tar_dest, 'wb') do |f|
          f.print tar_entry.read
        end
        FileUtils.chmod(tar_entry.header.mode, tar_dest, verbose: false)
      end

      def tar_symlink(tar_dest, tar_entry)
        File.symlink(tar_entry.header.linkname, tar_dest)
      end

      def longlink?(tar_entry)
        tar_entry.full_name == TAR_LONGLINK
      end

      def gzip_reader(archive)
        @gzip_reader ||= Zlib::GzipReader.open(archive)
      end

      def tar_reader(archive)
        @tar_reader ||= Gem::Package::TarReader.new(archive)
      end

      def longlink(destination, tar_entry)
        File.join(destination, tar_entry.read.strip)
      end

      def link(destination, tar_entry)
        File.join(destination, tar_entry.full_name)
      end

      def get_destination(tar_entry)
        if longlink?(tar_entry)
          longlink(@destination, tar_entry)
        else
          link(@destination, tar_entry)
        end
      end

    end
  end
end

