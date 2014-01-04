
cookbook_file 'java_tar_gz' do
  source 'java.tar.gz'
  path '/tmp/java.tar.gz'
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file 'jce_zip' do
  source 'jce.zip'
  path '/tmp/jce.zip'
  owner 'root'
  group 'root'
  mode 00644
end

jdk_install_flavor = 'oracle'
jdk_version = 7
java_home = "/usr/lib/jvm/java-#{ jdk_version }-#{ jdk_install_flavor }"

Chef::Log.info('Testing management of "oracle_jdk"')
java 'oracle_jdk' do
  install_type :tar
  install_options(
    source: '/tmp/java.tar.gz',
    jce_source: '/tmp/jce.zip',
    destination: java_home,
    strip_leading: true,
    install_jce: true
  )
end

java_alternatives 'oracle_jdk' do
  java_location java_home
end
