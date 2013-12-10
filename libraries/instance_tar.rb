# This will not download Java from anywhere.
# Take the path to a compress tarball containing Java
# Extract Java to destination directory

require 'chef/resource/directory'
require_relative 'tar_helper'

module ChefJava
  module Instance
    class Tar

      def initialize(options)
        @options = options
      end

      def install
        extract_tar
      end

      def remove
        remove_extracted_tar
      end

      private

      def archive
        @options[:source]
      end

      def destination
        @options[:destination]
      end

      #
      def extract_tar
        ChefJava::Helpers::Tar.new(archive, destination)
      end

      def remove_extracted_tar
        FileUtils.rm_rf(destination)
      end
    end
  end
end