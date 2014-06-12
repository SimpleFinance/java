source 'https://rubygems.org'

group :development do
  gem 'rake'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rubocop'
  gem 'coveralls'
  gem 'rubyzip', '>= 1.0.0'
  gem 'chef', '>= 11.8.2'
end

group :integration do
  gem 'kitchen-vagrant'
  gem 'berkshelf'
  gem 'test-kitchen', git: 'git://github.com/opscode/test-kitchen.git', branch: 'master'
  gem 'busser-minitest'
end
