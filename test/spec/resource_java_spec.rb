require_relative 'spec_helper'
require 'resource_java'

describe 'Chef::Resource::Java' do
  let(:node) do
    node = Chef::Node.new
    node.automatic[:platform] = 'ubuntu'
    node.automatic[:platform_version] = '12.04'
    node
  end
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:resource) { 'alternatives_test' }
  let(:java) do
    Chef::Resource::Java.new(resource, run_context)
  end

  before(:each) do
    @java_res = java
  end

  describe 'Chef Resource Checks for Chef::Resource::Java' do
    it 'Is a Chef::Resource?' do
      assert_kind_of(Chef::Resource, @java_res)
    end

    it 'Is a instance of Java' do
      assert_instance_of(Chef::Resource::Java, @java_res)
    end
  end

  describe 'Parameter tests for Chef::Resource::Java' do
    it "has a 'install_options' that can be set." do
      assert_respond_to(@java_res, :install_options)
      assert(@java_res.install_options(foo: 'bar'))
      assert_raises(Chef::Exceptions::ValidationFailed) do
        @java_res.install_options(%w(fail))
      end
    end

    it "has a 'install_type' that can be set." do
      assert_respond_to(@java_res, :install_type)
      assert(@java_res.install_type(:tar))
      assert_raises(Chef::Exceptions::ValidationFailed) do
        @java_res.install_type(%w(fail))
      end
    end
  end
end
