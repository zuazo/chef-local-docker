require 'dockerspec'
require 'dockerspec/serverspec'

path = ENV['DOCKERFILE_LOCATION'] || 'debian-7'

describe docker_build(path, tag: 'chef-local') do
  it { should have_cmd 'bash' }
  it { should have_env 'CHEF_REPO_PATH' }
  it { should have_env 'COOKBOOK_PATH' }

  describe docker_run('chef-local') do
    it 'installs Chef Client version 12' do
      expect(command('chef-client --version').stdout).to match(/^Chef: 12\./)
    end

    it 'installs berks' do
      expect(command('berks --version').exit_status).to eq(0)
    end

    it 'sets locale to UTF-8' do
      expect(command('locale').stdout).to include('UTF-8')
    end

    it 'creates cookbook path directory' do
      expect(file('/tmp/chef/cookbooks')).to be_directory
    end

    context 'in chef configuration' do
      let(:config) { '/etc/chef/client.rb' }
      let(:config_file) { file(config) }

      it 'sets cookbook path' do
        expect(config_file.content)
          .to include('cookbook_path %w(/tmp/chef/cookbooks)')
      end

      it 'sets local mode' do
        expect(config_file.content).to include('local_mode true')
      end

      it 'enables chef zero' do
        expect(config_file.content).to include('chef_zero.enabled true')
      end
    end

    it 'installs git' do
      expect(command('git --version').exit_status).to eq(0)
    end
  end
end
