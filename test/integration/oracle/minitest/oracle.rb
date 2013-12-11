require 'minitest/autorun'

  describe 'oracle::oracle' do

    it 'should extract java to /opt' do
      assert File.exists?('/opt/java')
    end

  end
