require 'simplecov'
require 'codeclimate-test-reporter'

formatters = [SimpleCov::Formatter::HTMLFormatter]
formatters << CodeClimate::TestReporter::Formatter if ENV['TRAVIS']
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[*formatters]
SimpleCov.start do
  add_filter '/.bundle'
  add_filter '/spec'
end

require 'rspec'

RSpec.configure do |config|
  config.before(:each) do |example|
    SimpleCov.command_name(example.location)
  end
end

require 'lean-attributes'
require 'fixtures.rb'
