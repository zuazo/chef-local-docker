# -*- mode: ruby -*-
# vi: set ft=ruby :

# More info at https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc

images = %w(
  centos-6
  debian-7
  ubuntu-12.04
  ubuntu-14.04
)

require 'bundler/setup'
require 'rspec/core/rake_task'

task :rspec do
  RSpec::Core::RakeTask.new(:rspec)
end

images.each do |image|
  desc "Test #{image} image"
  task image do
    ENV['DOCKERFILE_LOCATION'] = image
    RSpec::Core::RakeTask.new(image)
  end
end

desc 'Test all images'
task test: images

task default: %w(rspec)
