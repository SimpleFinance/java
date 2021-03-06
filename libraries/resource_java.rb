require 'chef/resource'
require_relative 'provider_java'

class Chef
  class Resource
    # Install Java from various sources.
    class Java < Chef::Resource
      state_attrs :install_type

      def initialize(name, run_context = nil)
        super
        @resource_name = :java
        @action = :create
        @allowed_actions = [:create, :destroy]
        @provider = Chef::Provider::Java
      end

      def install_options(arg = nil)
        set_or_return(:install_options, arg, kind_of: Hash)
      end

      def install_type(arg = nil)
        set_or_return(:install_type, arg, kind_of: Symbol)
      end
    end
  end
end
