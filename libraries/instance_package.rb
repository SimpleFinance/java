require 'chef/resource/package'

module ChefJava
  module Instance
    # Take a Java package and install it.
    class Package
      def initialize(options)
        @options = options
      end

      def install
      end

      def remove
      end

      private

      def set_package_resource
        @package ||= Chef::Resource::Package.new(package_name)
      end

      def package_name
        @package_name ||= @options.fetch(:provider)
      end

      def rendered_package_version
        @pkg_version ||= "#{ pkg_version }u#{ pkg_update }-#{ pkg_release }"
      end

      def pkg_version
        @options.fetch(:version)
      end

      def pkg_update
        @options.fetch(:update)
      end

      def pkg_release
        @options.fetch(:release)
      end

      def pkg_source
        @options.fetch(:source)
      end

      def pkg_options
        @options.fetch(:options)
      end

      def pkg_response_file
        @options.fetch(:response_File)
      end

      def package_resource(res, action)
        res.version rendered_package_version
        res.source if pkg_source
        res.options if pkg_options
        res.action action
      end
    end
  end
end
