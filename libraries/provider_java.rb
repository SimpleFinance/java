require 'chef/provider'

class Chef
  class Provider
    class Java < Chef::Provider

      def initialize(new_resource, run_context)
        super
      end

      def whyrun_supported?
        false
      end

      def load_current_resource
      end

      def action_create
      end

      def action_destroy
      end

      private

      def perform_action
      end

      def installer
      end

    end
  end
end