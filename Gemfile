source 'https://rubygems.org'

gemspec

unless ENV['TRAVIS']
  gem 'yard', require: false
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.9',  require: nil
  gem 'pry',                       '~> 0.10.1'
  gem 'simplecov',                 '~> 0.9.2',  require: nil
  gem 'simplecov-html',            '~> 0.10.2',  require: nil
end
