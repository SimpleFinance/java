# This will not download Java from anywhere.
# Take the path to a compress tarball containing Java
# Extract Java to destination directory

require 'chef/resource/directory'

module ChefJava
  module Instance
    class Tar

      def initialize(path, options, action)
        @path = path
        @options = options
        @action = action
      end

      def install
      end

      def remove
      end

      private

      # TODO: Memoize this.
      def manage_directory
        dir = Chef::Directory.new(@path)
        dir.owner 'root'
        dir.group 'root'
        dir.mode 00755
        dir.run_action(:create)
      end

      #
      def tar
      end

      def decompress
      end

    end
  end
end