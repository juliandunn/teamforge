require 'spec_helper'

describe 'teamforge::server' do

  it 'should install a package called teamforge' do
    chef_run = ChefSpec::ChefRunner.new({:platform => 'centos', :version => '6.3'})
    # Don't know why platform_family isn't included in the fauxhai mock
    chef_run.node.automatic_attrs['platform_family'] = 'rhel'
    # Set a secret to avoid errors
    chef_run.node.set['teamforge']['server']['scm_default_shared_secret'] = 'abcd1234abcd1234'
    chef_run.converge 'teamforge::server'
    expect(chef_run).to install_package 'teamforge'
  end
end
