
Chef::Log.info('Testing management of "oracle_jdk"')
java 'oracle_jdk' do
  install_type :tar
  install_options({
    provider: :oracle,
    version: 7,
    update: 45,
    install_jce: true
  })
end