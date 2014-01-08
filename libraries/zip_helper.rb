require 'chef/resource/chef_gem'

module ChefJava
  module Helpers
    # Helps extract zip files.
    class Zip
      def initialize(archive, destination, run_context)
        @archive = archive
        @destination = destination
        @run_context = run_context
      end

      def extract_zip
        zip.extract(@archive, @destination)
      rescue => error
        Chef::Log.info(error)
      end

      def extract(entries)
        entries.each do |entry|
          zip.extract(entry, @destination)
        end
      end

      def entries
        zip.entries
      end

      def safe_handle
        install_gem
        safe_require
        zip_setup
        ::Zip::File.open(@archive)
      rescue => error
        Chef::Log.info(error)
      end

      private

      def zip
        @zip ||= zip_handle
      end

      def safe_require
        require 'zip'
      rescue => error
        Chef::Log.info(error)
      end

      def zip_setup
        ::Zip.on_exists_proc = true
      end

      def install_gem
        gem = Chef::Resource::ChefGem.new('rubyzip', @run_context)
        gem.run_action(:install)
      rescue => error
        Chef::Log.info(error)
      end
    end
  end
end
