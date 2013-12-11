require 'minitest/autorun'

  describe 'java_test::oracle' do

    it 'should extract java to /opt' do
      assert File.exists?('/opt/java')
    end

  end
