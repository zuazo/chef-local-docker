require_relative '../spec_helper'

describe "Dockerfile build on #{ENV['DOCKERFILE_LOCATION']}" do
  it 'creates image' do
    expect(image).not_to be_nil
  end

  it 'runs bash in foreground' do
    expect(image_config['Cmd']).to include 'bash'
  end

  context 'on environment' do
    let(:env_keys) { image_config['Env'].map { |x| x.split('=', 2)[0] } }

    it 'sets repository path' do
      expect(env_keys).to include('CHEF_REPO_PATH')
    end

    it 'sets cookbook path' do
      expect(env_keys).to include('COOKBOOK_PATH')
    end
  end
end
