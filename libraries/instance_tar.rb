# This will not download Java from anywhere.
# Take the path to a compress tarball containing Java
# Extract Java to destination directory

require_relative 'tar_helper'
require_relative 'zip_helper'

module ChefJava
  module Instance
    # Drive tar extraction.
    class Tar
      def initialize(options)
        @options = options
      end

      def install
        extract_tar
        extract_jce
      end

      def remove
        remove_extracted_tar
      end

      private

      def archive
        @options.fetch(:source) { :tar_source_unspecified }
      end

      def destination
        @options.fetch(:destination) { :tar_destination_unspecified }
      end

      def install_jce?
        @options.fetch(:install_jce) { false }
      end

      def extract_tar
        tar = ChefJava::Helpers::Tar.new(archive, destination)
        tar.extract_tar
      end

      def extract_jce
        jce = ChefJava::Helpers::Zip.new(archive, destination)
        jce.extract_zip
      end

      def remove_extracted_tar
        FileUtils.rm_rf(destination)
      end
    end
  end
end
