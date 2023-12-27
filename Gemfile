# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in rggen-duh.gemspec
gemspec

root = ENV['RGGEN_ROOT'] || File.expand_path('..', __dir__)
gemfile = File.join(root, 'rggen-devtools', 'gemfile', 'common.gemfile')
eval_gemfile(gemfile)

group :rggen do
  gem_patched 'facets'
end

if ENV.key?('CI')
  require File.join(root, 'stdgems-version/lib/stdgems_version')
  gem 'bigdecimal', StdgemsVersion.version('bigdecimal')
else
  gem 'bigdecimal'
end
