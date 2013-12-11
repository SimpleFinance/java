require 'minitest/autorun'

describe 'java_test::oracle' do

  it 'should have /tmp/java.tar.gz' do
    assert(File.exists?('/tmp/java.tar.gz'),
           'Java Tarball missing.')
  end

  it 'should extract java to /opt' do
    assert(File.directory?('/opt/java'),
           '/opt/java doesnt exist.')
  end

  it 'should create a java binary' do
    assert(File.exists?('/opt/java/bin/java'),
           '/opt/java/bin/java is missing.')
  end

  it 'should create a symlink' do
    assert(File.symlink?('/opt/java/sbin'),
           '/opt/java/sbin is not a symlink.')
  end

end
