require 'chef/resource/chef_gem'

module ChefJava
  module Helpers
    class Zip
      def initialize(archive, destination, run_context)
        @archive = archive
        @destination = destination
        @run_context = run_context
      end

      def extract_zip
        zip = zip_reader
        zip.extract(@archive, @destination)
      rescue => error
        Chef::Log.info(error)
      end

      private

      def safe_require
        require 'zip'
      rescue => error
        Chef::Log.info(error)
      end

      def install_gem
        gem = Chef::Resource::ChefGem.new('rubyzip', @run_context)
        gem.run_action(:install)
      rescue => error
        Chef::Log.info(error)
      end

      def zip_reader
        install_gem
        safe_require
        ::Zip::File.open(@archive)
      rescue => error
        Chef::Log.info(error)
      end
    end
  end
end