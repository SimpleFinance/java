
java 'openjdk' do
  install_type :package
  install_options({
    provider: :openjdk,
    version: 7,
    update: 25,
    release: '2.3.10-1'
  })
end