# frozen_string_literal: true

require_relative 'lib/semvruler/version'

Gem::Specification.new do |spec|
  spec.name          = 'semvruler'
  spec.version       = Semvruler::VERSION
  spec.authors       = ['Monica L. Quiros']
  spec.email         = ['nika.kirosh@gmail.com']

  spec.summary       = 'Utility to match and compare semantic versions in ruby'
  spec.homepage      = 'https://github.com/nika-kirosh/semvruler'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['allowed_push_host'] = 'http://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/nika-kirosh/semvruler/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
