
module ChefJava
  module Instance
    # Take a Java package and install it.
    class Package
      def initialize(options)
        @options = options
      end

      def self.installed?
      end

      def self.version
      end

      def install
        true
      end

      def remove
        true
      end
    end
  end
end
