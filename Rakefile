# ==============================================================================
#   CMock Project - Automatic Mock Generation for C
#   Copyright (c) 2007-2014 Mike Karlesky, Mark VanderVoord, Greg Williams
#   [Released under MIT License. Please refer to license.txt for details]
# ==============================================================================

require './config/test_environment'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require './rakefile_helper'

require 'rspec/core/rake_task'

include RakefileHelpers

DEFAULT_CONFIG_FILE = 'gcc.yml'
CMOCK_ROOT = File.expand_path(File.dirname(__FILE__))

SYSTEM_TEST_SUPPORT_DIRS = [
  File.join(CMOCK_ROOT, 'test/system/generated'),
  File.join(CMOCK_ROOT, 'test/system/build')
]

SYSTEM_TEST_SUPPORT_DIRS.each do |dir|
  directory(dir)
  CLOBBER.include(dir)
end


task :prep_system_tests => SYSTEM_TEST_SUPPORT_DIRS

configure_clean
configure_toolchain(DEFAULT_CONFIG_FILE)

task :default => ['test:all']
task :ci => [:no_color, :default]
task :cruise => :ci

desc "Load configuration"
task :config, :config_file do |t, args|
  args = {:config_file => DEFAULT_CONFIG_FILE} if args[:config_file].nil?
  args = {:config_file => args[:config_file] + '.yml'} unless args[:config_file] =~ /\.yml$/i
  configure_toolchain(args[:config_file])
end

namespace :test do
  desc "Run all unit and system tests"
  task :all => [:clobber, :prep_system_tests, 'test:units', 'test:c', 'test:system']

  desc "Run Unit Tests"
  Rake::TestTask.new('units') do |t|
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true
  end

  #individual unit tests
  FileList['test/unit/*_test.rb'].each do |test|
    Rake::TestTask.new(File.basename(test,'.*')) do |t|
      t.pattern = test
      t.verbose = true
    end
  end

  desc "Run C Unit Tests"
  task :c => [:prep_system_tests] do
    build_and_test_c_files
  end

  desc "Run System Tests"
  task :system => [:clobber, :prep_system_tests] do
    #get a list of all system tests, removing unsupported tests for this compiler
    sys_unsupported  = $cfg['unsupported'].map {|a| 'test/system/test_interactions/'+a+'.yml'}
    sys_tests_to_run = FileList['test/system/test_interactions/*.yml'] - sys_unsupported
    compile_unsupported  = $cfg['unsupported'].map {|a| SYSTEST_COMPILE_MOCKABLES_PATH+a+'.h'}
    compile_tests_to_run = FileList[SYSTEST_COMPILE_MOCKABLES_PATH + '*.h'] - compile_unsupported
    unless (sys_unsupported.empty? and compile_unsupported.empty?)
      report "\nIgnoring these system tests..."
      sys_unsupported.each {|a| report a}
      compile_unsupported.each {|a| report a}
    end
    report "\nRunning system tests..."
    tests_failed = run_system_test_interactions(sys_tests_to_run)
    raise "System tests failed." if (tests_failed > 0)

    run_system_test_compilations(compile_tests_to_run)
  end

  #individual system tests
  FileList['test/system/test_interactions/*.yml'].each do |test|
    desc "Run system test #{File.basename(test,'.*')}"
    task "test:#{File.basename(test,'.*')}" do
      run_system_test_interactions([test])
    end
  end

  desc "Profile Mock Generation"
  task :profile => [:clobber, :prep_system_tests] do
    run_system_test_profiles(FileList[SYSTEST_COMPILE_MOCKABLES_PATH + '*.h'])
  end
end

task :no_color do
  $colour_output = false
end

RSpec::Core::RakeTask.new(:spec) do |t|
  spec_path = File.join(CMOCK_ROOT, 'test/spec')
  t.pattern = spec_path + '/*_spec.rb'
end

