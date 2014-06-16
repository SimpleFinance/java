require 'minitest/autorun'

describe 'java_test::oracle' do

  it 'should have /tmp/java.tar.gz' do
    assert(File.exist?('/tmp/java.tar.gz'),
           'Java Tarball missing.')
  end

  it 'should extract java to /opt' do
    assert(File.directory?('/opt/java'),
           '/opt/java doesnt exist.')
  end

  it 'should extract jce to /opt/jce' do
    assert(File.directory?('/opt/lib/security'),
           '/opt/lib/security doesnt exist.')
  end

  it 'should create a jce_lib file' do
    assert(File.exist?('/opt/lib/security/jce_lib'),
           '/opt/lib/security/jce_lib is missing.')
  end

  it 'should create a java binary' do
    assert(File.exist?('/opt/java/bin/java'),
           '/opt/java/bin/java is missing.')
  end

  it 'should create a symlink' do
    assert(File.symlink?('/opt/java/sbin'),
           '/opt/java/sbin is not a symlink.')
  end
end
