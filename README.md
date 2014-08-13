java
====

```
java 'oracle_jdk' do
  install_type :tar
  install_options: {
    provider: :oracle,
    version: 7,
    update: 45,
    install_jce: true
  }
end
```

```
java 'openjdk' do
  install_type :package
  install_options: {
    provider: :openjdk,
    version: 7,
    update: 25,
    release: '2.3.10-1'
  }
end
```
