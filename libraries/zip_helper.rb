
module ChefJava
  module Helper
    class Zip
      def initialize(archive, destination)
        @archive = archive
        @destination = destination
      end

      def extract_zip
        zip = zip_reader
        zip.extract(@archive, @destination)
      rescue => error
        Chef::Log.debug("[Zip#extract_zip] Unknown Error: #{ error }")
      ensure
        zip.close
      end

      private

      def safe_require
        require 'zip' if install_gem
      end

      def install_gem
        gem = Chef::Resource::ChefGem.new('rubyzip')
        gem.run_action(:install)
      end

      def zip_reader
        Zip::ZipFile.open(archive)
      end
    end
  end
end