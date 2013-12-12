# This is a wrapper around the Rubygems TarReader and Zlib

require 'rubygems/package'
require 'zlib'

module ChefJava
  module Helpers
    # Take gzipped tarball and extract it to a location.
    class Tar
      def initialize(archive, destination)
        @archive = archive
        @destination = destination
      end

      TAR_LONGLINK = '././@LongLink'

      def extract_tar
        Chef::Log.debug("[Tar#extract_tar] Archive is #{ @archive }")
        Chef::Log.debug("[Tar#extract_tar] Destination is #{ @destination }")
        if valid_archive_and_destination?(@archive, @destination)
          Chef::Log.info('[Tar#extract_tar] Archive and destination are valid.')
          tar = tar_reader(gzip_reader(@archive))
          tar.each do |entry|
            Chef::Log.debug("[Tar#extract_tar] Iteration: #{ entry }")
            write_file(get_destination(entry), entry)
          end
        else
          Chef::Log.info("[Tar#extract_tar] Archive #{ @archive } is invalid.")
        end
      end

      private

      def valid_archive_and_destination?(archive, destination)
        valid_archive?(archive)
        valid_destination?(destination)
      end

      def valid_archive?(archive)
        File.file?(archive)
      end

      def valid_destination?(destination)
        File.directory?(destination)
      end

      def write_file(dest, entry)
        Chef::Log.debug('[Tar#write_file] Writing files.')
        if entry.directory?
          Chef::Log.debug("[Tar#write_file] mkdir #{ dest } at #{ entry }")
          tar_mkdir(dest, entry)
        elsif entry.file?
          Chef::Log.debug("[Tar#write_file] file #{ dest } at #{ entry }")
          tar_file(dest, entry)
        elsif entry_symlink?(entry)
          Chef::Log.debug("[Tar#write_file] symlink #{ dest } at #{ entry }")
          tar_symlink(dest, entry)
        else
          Chef::Log.debug("[Tar#write_file] Unsure how to handle #{ entry.header }")
        end
      end

      def entry_symlink?(tar_entry)
        tar_entry.header.typeflag == '2'
      end

      def tar_mkdir(tar_dest, tar_entry)
        FileUtils.rm_rf(tar_dest) unless File.directory?(tar_dest)
        FileUtils.mkdir_p(tar_dest,
                          mode: tar_entry.header.mode,
                          verbose: false)
      end

      def tar_file(tar_dest, tar_entry)
        FileUtils.rm_rf(tar_dest) unless File.file?(tar_dest)
        File.open(tar_dest, 'wb') do |f|
          f.write tar_entry.read
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
        begin
          zip = Zlib::GzipReader.open(archive)
          io = StringIO.new(zip.read)
          zip.close
          io.rewind
          io
        rescue => error
          Chef::Log.debug("[Tar#gzip_reader] Unknown Error: #{ error }")
        end
      end

      def tar_reader(archive)
        begin
          tar = Gem::Package::TarReader.new(archive)
          tar
        rescue => error
          Chef::Log.debug("[Tar#tar_reader] Unknown Error: #{ error }")
        end
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
