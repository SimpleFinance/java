require 'minitest/autorun'

describe 'java_test::openjdk' do
  it 'should have openjdk package installed' do
    skip
  end

  it 'should have /usr/bin/java' do
    skip
    assert(File.exists?('/usr/bin/java'),
           'Java missing.')
  end
end