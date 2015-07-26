# -*- mode: ruby -*-
# vi: set ft=ruby :

# More info at https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc

images = %w(
  centos-6
  centos-7
  centos-7-systemd
  debian-6
  debian-7
  debian-8
  fedora-20
  fedora-22
  fedora-rawhide-systemd
  ubuntu-12.04
  ubuntu-12.04-upstart
  ubuntu-14.04
  ubuntu-14.04-upstart
  ubuntu-15.04
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
