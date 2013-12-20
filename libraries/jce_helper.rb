require_relative 'zip_helper'

module ChefJava
  module Helpers
    # Deal with the Jce policy zip.
    class Jce
      def initialize(archive, destination, run_context)
        @archive = archive
        @destination = destination
        @run_context = run_context
      end

      def extract
        jce_files.each do |file|
          zip_handle.extract(file, jce_destination(file))
        end
      end

      private

      def zip
        @zip ||= ChefJava::Helpers::Zip.new(@archive,
                                            jce_path,
                                            @run_context)
      end

      def zip_handle
        zip.safe_handle
      end

      def jce_files
        open_zip = zip_handle
        files = open_zip.map { |entry| entry.ftype == :file ? entry : nil }
        files.compact!
        files
      end

      def jce_path
        File.join(@destination, 'lib', 'security')
      end

      def jce_file_name(entry)
        entry.name.split('/').last
      end

      def jce_destination(file)
        File.join(jce_path, jce_file_name(file))
      end
    end
  end
end
