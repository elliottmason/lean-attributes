lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'lean-attributes/version'

Gem::Specification.new do |s|
  s.name = 'lean-attributes'
  s.version = Lean::Attributes::VERSION

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.rubygems_version = '>= 1.3.6'

  s.homepage = 'https://github.com/lleolin/lean-attributes'
  s.authors = ['R. Elliott Mason']
  s.email = ['r.elliott.mason@fastmail.fm']
  s.summary = 'Lean attributes for Ruby classes'
  s.description = <<-desc
lean-attributes allows you to define coerced attributes for Ruby classes
desc

  s.licenses = ['MIT']

  s.files = `git ls-files -- {bin,lib}/*`.split("\n") +
    %w(LICENSE README.md)
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md']
  s.require_paths = ['lib']

  s.add_development_dependency 'rake',  '~> 10.3',  '>= 10.3.2'
  s.add_development_dependency 'rspec', '~> 3.0',   '>= 3.0.0'
end
