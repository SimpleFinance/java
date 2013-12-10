require 'chef/resource'

class Chef
  class Resource
    class Java < Chef::Resource

      state_attrs :install_type

      def initialize(name, run_context=nil)
        super
        @resource_name = :java
        @action = :create
        @allowed_actions.push(:create, :destroy)
      end

      def install_options(arg=nil)
        set_or_return(:install_options, arg, kind_of: Symbol)
      end

      def install_type(arg=nil)
        set_or_return(:install_type, arg, kind_of: Hash)
      end

      private

    end
  end
end