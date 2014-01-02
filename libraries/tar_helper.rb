# This is a wrapper around the Rubygems TarReader and Zlib

require 'rubygems/package'
require 'zlib'

module ChefJava
  module Helpers
    # Take gzipped tarball and extract it to a location.
    class Tar
      def initialize(archive, destination, options)
        @archive = archive
        @destination = destination
        @options = options
      end

      def extract_tar
        if valid_archive_and_destination?(@archive, @destination)
          tar = tar_reader(gzip_reader(@archive))
          full_name = nil
          tar.each do |entry|
            Chef::Log.debug("Iteration: #{ entry.full_name }")
            if longlink?(entry)
              full_name = longlink(entry)
              next
            end
            full_name ||= link(entry)
            dest = get_destination(@destination, full_name)
            Chef::Log.debug("Destination is #{ dest }")
            write_file(dest, entry)
            full_name = nil
          end
        else
          Chef::Log.info("Archive #{ @archive } is invalid.")
        end
      end

      private

      def valid_archive_and_destination?(archive, destination)
        valid_archive?(archive)
        unless valid_destination?(destination)
          create_destination(destination)
        end
      end

      def valid_archive?(archive)
        File.file?(archive)
      end

      def valid_destination?(destination)
        File.directory?(destination)
      end

      def write_file(dest, entry)
        if entry.directory?
          tar_mkdir(dest, entry)
        elsif entry.file?
          tar_file(dest, entry)
        elsif entry_symlink?(entry)
          tar_symlink(dest, entry)
        else
          Chef::Log.debug(
              "Unsure how to handle #{ entry.full_name }")
        end
      end

      def entry_symlink?(tar_entry)
        tar_entry.header.typeflag == '2'
      end

      def tar_mkdir(tar_dest, tar_entry)
        Chef::Log.debug("mkdir #{ tar_dest } at #{ tar_entry.full_name }")
        FileUtils.rm_rf(tar_dest) unless File.directory?(tar_dest)
        FileUtils.mkdir_p(tar_dest,
                          mode: tar_entry.header.mode,
                          verbose: false)
      end

      def tar_file(tar_dest, tar_entry)
        Chef::Log.debug("file #{ tar_dest } at #{ tar_entry.full_name }")
        FileUtils.rm_rf(tar_dest) unless File.file?(tar_dest)
        File.open(tar_dest, 'wb') do |f|
          f.write tar_entry.read
        end
        FileUtils.chmod(tar_entry.header.mode, tar_dest, verbose: false)
      end

      def tar_symlink(tar_dest, tar_entry)
        Chef::Log.debug("symlink #{ tar_dest } at #{ tar_entry.full_name }")
        File.symlink(tar_entry.header.linkname, tar_dest)
      end

      def longlink?(tar_entry)
        tar_entry.full_name.eql?(tar_longlink)
      end

      def gzip_reader(archive)
        zip = Zlib::GzipReader.open(archive)
        io = StringIO.new(zip.read)
        io.rewind
        io
      rescue => error
        Chef::Log.debug("[Tar#gzip_reader] Unknown Error: #{ error }")
      ensure
        zip.close
      end

      def tar_longlink
        '././@LongLink'
      end

      def tar_reader(archive)
        tar = Gem::Package::TarReader.new(archive)
        tar
      rescue => error
        Chef::Log.debug("[Tar#tar_reader] Unknown Error: #{ error }")
      ensure
        tar.close
      end

      def longlink(tar_entry)
        tar_entry.read.strip
      end

      def link(tar_entry)
        tar_entry.full_name
      end

      def strip_leading?
        @options.fetch(:strip_leading) { false }
      end

      def create_destination(destination)
        Chef::Log.debug("Creating #{ destination } directory.")
        FileUtils.mkdir_p(destination)
      end

      def get_destination(destination, tar_entry)
        if strip_leading?
          ::File.join(destination, tar_entry.split('/').drop(1))
        else
          ::File.join(destination, tar_entry)
        end
      end
    end
  end
end
