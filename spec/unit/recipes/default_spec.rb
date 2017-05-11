#
# Cookbook Name:: ds_api
# Spec:: default
#
# Copyright (c) 2016 The Dark Sky Company, LLC, All Rights Reserved.

require 'spec_helper'

describe 'ds_api::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        server.create_environment 'test', {}

        node.chef_environment = 'test'

        node.default['ds_base']['efs']['id'] = nil

        server.create_data_bag(
          'secrets',
          'ssh_keys' => {
            'darkskybot' => {
              'privkey' => "-----BEGIN RSA PRIVATE KEY-----\nFAKE_PRIVATE_KEY\n-----END RSA PRIVATE KEY-----\n",
              'pubkey'  => "ssh-rsa FAKE_PUBLIC_KEY ds_api Chef cookbook\n",
            },
          }
        )
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs libcairo' do
      expect(chef_run).to install_package 'libcairo-dev'
    end

    %w(
      ds_common_basics
      lockrun
      chef_nginx
    ).each do |recipe|
      it "includes the #{recipe} recipe" do
        expect(chef_run).to include_recipe recipe
      end
    end

    it 'clones the API code' do
      %w(
        /srv/api
        /srv/api/var
      ).each do |d|
        expect(chef_run).to create_directory(d).with(
          owner: 'darksky',
          group: 'darksky'
        )
      end

      expect(chef_run).to sync_git('/srv/api').with(
        user: 'darksky'
      )
    end

    it 'installs the API node_modules' do
      expect(chef_run).to install_nodejs_npm('api').with(
        path:    '/srv/api',
        json:    true,
        user:    'darksky',
        options: %w(--production)
      )
    end

    it 'enables the API service using NGINX + Passenger' do
      expect(chef_run).to enable_nginx_site 'api'
    end

    it 'sets up the generated data syncing' do
      expect(chef_run).to create_directory '/var/run/api'

      expect(chef_run).to create_lockrun_cron 'sync_dsgm'
      expect(chef_run).to create_lockrun_cron 'sync_nn'
    end

    it 'syncs dsgm files' do
      expect(chef_run).to run_execute 'sync_dsgm'
      expect(chef_run).to run_execute 'sync_nn'
    end
  end
end
