require 'chef/provider'
require_relative('instance_tar')
require_relative('instance_package')

class Chef
  class Provider
    # Install Java from various sources.
    class Java < Chef::Provider
      def initialize(new_resource, run_context)
        super
        @install_type = new_resource.install_type
        @install_options = new_resource.install_options
      end

      def whyrun_supported?
        false
      end

      def load_current_resource
      end

      def action_create
        instance(@new_resource.install_type, :install)
        @new_resource.updated_by_last_action(true)
      end

      def action_destroy
        instance(@new_resource.install_type, :remove)
        @new_resource.updated_by_last_action(true)
      end

      private

      def instance(type, action)
        instance_class = instance_sub_class(type)
        i = instance_class.new(@install_options, @run_context)
        i.send(action)
      end

      def instance_sub_class(type)
        klass = "ChefJava::Instance::#{ type_to_sc(type) }"
        klass.split('::').reduce(Object) { |a, e| a.const_get(e) }
      end

      def type_to_sc(type)
        type.to_s.capitalize
      end
    end
  end
end
