# frozen_string_literal: true

require File.expand_path('lib/rggen/duh/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rggen-duh'
  spec.version = RgGen::DUH::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['rggen@googlegroups.com']

  spec.summary = "rggen-dut-#{RgGen::DUH::VERSION}"
  spec.description = 'DUH support for RgGen'
  spec.homepage = 'https://github.com/rggen/rggen-duh'
  spec.license = 'MIT'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rggen/rggen/issues',
    'mailing_list_uri' => 'https://groups.google.com/d/forum/rggen',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/rggen/rggen-duh',
    'wiki_uri' => 'https://github.com/rggen/rggen/wiki'
  }

  spec.files =
    `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.1')

  spec.add_runtime_dependency 'json_refs', '>= 0.1.4'
  spec.add_runtime_dependency 'json_schemer', '>= 2.0.0'
  spec.add_runtime_dependency 'rb_json5', '>= 0.3.0'
end
