require 'dockerspec'
require 'dockerspec/serverspec'

from = ENV['DOCKERFILE_LOCATION'] || 'debian-7'

sources = {
  supermarket: 'Running a cookbook from Supermarket',
  cookbook: 'Running a cookbook a local directory',
  github: 'Running a cookbook from GitHub'
}

shared_examples 'having netstat installed' do |from_image|
  describe package('net-tools') do
    it { should be_installed }
  end

  describe file('/bin/netstat') do
    it { should be_file }
    it { should be_executable }
  end

  describe user('netstat') do
    it { should exist }
  end

  describe process('netstat'), if: from_image.match('systemd').nil? do
    it { should be_running }
    its(:user) { should eq 'netstat' }
    its(:args) { should match(/-tunac/) }
  end
end

sources.each do |source, desc|
  describe desc do
    describe docker_build(from, tag: "chef-local:#{from}") do
      describe docker_build(
        template: "spec/dockerfiles/netstat_#{source}/Dockerfile.erb",
        context: { from: "chef-local:#{from}" },
        tag: "netstat_#{source}:#{from}"
      ) do
        it { should have_cmd 'netstat -tunac' }
        it { should have_user 'netstat' }

        describe docker_run("netstat_#{source}:#{from}") do
          it_behaves_like 'having netstat installed', from
        end # docker_run
      end
    end # docker_build netstat_github
  end # docker_build from
end
