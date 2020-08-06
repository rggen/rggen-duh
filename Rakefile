# frozen_string_literal: true

require 'bundler/setup'
require 'fileutils'
require 'rggen/devtools/rake_helper'

RgGen::Devtools::RakeHelper.setup_default_tasks

desc 'build duh-schema'
task :build_schema do
  root = __dir__
  Dir.chdir(File.join(root, 'duh-schema', 'bin')) do
    system('./prepare.js')
    FileUtils.move(
      './dist/schema.json', File.join(root, 'lib', 'rggen', 'duh')
    )
  end
end
