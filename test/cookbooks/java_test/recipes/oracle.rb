
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

directory '/opt/lib/security' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
end

Chef::Log.info('Testing management of "oracle_jdk"')
java 'oracle_jdk' do
  install_type :tar
  install_options(
    source: '/tmp/java.tar.gz',
    jce_source: '/tmp/jce.zip',
    destination: '/opt',
    provider: :oracle,
    version: 7,
    update: 45,
    install_jce: true
  )
end
