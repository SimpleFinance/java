require_relative 'spec_helper'
require 'resource_alternatives'

describe 'Chef::Resource::JavaAlternatives' do

  let(:node) do
    node = Chef::Node.new
    node.automatic[:platform] = 'ubuntu'
    node.automatic[:platform_version] = '12.04'
    node
  end
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:resource) { 'alternatives_test' }
  let(:alternatives) do
    Chef::Resource::JavaAlternatives.new(resource, run_context)
  end

  before(:each) do
    @alternatives_res = alternatives
  end

  describe 'Chef Resource Checks for Chef::Resource::JavaAlternatives' do
    it 'Is a Chef::Resource?' do
      assert_kind_of(Chef::Resource, @alternatives_res)
    end

    it 'Is a instance of JavaAlternatives' do
      assert_instance_of(Chef::Resource::JavaAlternatives, @alternatives_res)
    end
  end

  describe 'Parameter tests for Chef::Resource::JavaAlternatives' do
    it "has a 'java_location' that can be set." do
      assert_respond_to(@alternatives_res, :java_location)
      assert(@alternatives_res.java_location('/test'))
      assert_raises(Chef::Exceptions::ValidationFailed) do
        @alternatives_res.java_location(%w(fail))
      end
    end

    it "has a 'bin_cmds' that can be set." do
      assert_respond_to(@alternatives_res, :bin_cmds)
      assert(@alternatives_res.bin_cmds(%w(foo bar baz)))
      assert_raises(Chef::Exceptions::ValidationFailed) do
        @alternatives_res.bin_cmds('java')
      end
    end

    it "has a 'default' that can be set." do
      assert_respond_to(@alternatives_res, :default)
      assert(@alternatives_res.default(true))
      assert_raises(Chef::Exceptions::ValidationFailed) do
        @alternatives_res.default('true')
      end
    end

    it "has a 'priority' that can be set." do
      assert_respond_to(@alternatives_res, :priority)
      assert(@alternatives_res.priority(42))
      assert_raises(Chef::Exceptions::ValidationFailed) do
        @alternatives_res.priority('42')
      end
    end
  end
end
