require 'minitest/autorun'

describe Chef::Resource::Alternatives do
  describe 'java_location' do

    it 'Allows setting a path where java will be installed.' do
      true.should == false
    end

  end
end