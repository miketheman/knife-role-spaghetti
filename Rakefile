#!/usr/bin/env rake
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/clean'

CLEAN.include('tmp/*')
CLOBBER.include('pkg/*')

begin
  require 'appraisal'
rescue LoadError
  puts 'Unable to load appraisal gem - will test against only latest version of the dependency.' unless ENV['CI']
end

task :test => [:tailor, :features, :cane]

task :default => :test

# https://github.com/turboladen/tailor
require 'tailor/rake_task'
Tailor::RakeTask.new do |task|
  task.file_set('lib/**/*.rb', 'code')
end

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = ['features', '-x']
  t.cucumber_opts += ['--format progress']
end

require 'cane/rake_task'
Cane::RakeTask.new do |t|
  t.canefile = './.cane'
end

# File lib/tasks/notes.rake
desc 'Find notes in code'
task :notes do
  puts `grep --exclude=Rakefile -r 'OPTIMIZE:\\|FIXME:\\|TODO:' .`
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:style)
