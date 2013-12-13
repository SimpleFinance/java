module ChefJava
  module Helpers
    # Handle updating via 'alternatives'
    class Alternatives
      def initialize
      end

      def render_content(options)
        puts %Q(
        name=#{ options.name }
        priority=#{ options.priority }
        section=main
        #{ bin_commands }
        )
      end

      private

      def bin_commands
      end

      def create_links
      end

    end
  end
end
