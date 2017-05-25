#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::profile::r10k', :type => :class do
  on_supported_os.each do |os, facts|
    context "When on an #{os} system" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :fqdn           => 'constructorfleet.vogon.gal',
          :domain         => 'vogon.gal',
          :puppetversion  => Puppet.version,
          :is_pe          => false,
        })
      end
      it { is_expected.to compile.with_all_deps }
      if Puppet.version.to_f >= 4.0
        confdir        = '/etc/puppetlabs/puppet'
        codedir        = '/etc/puppetlabs/code'
      else
        confdir        = '/etc/puppet'
        codedir        = '/etc/puppet'
      end
      context 'when fed no parameters' do
        it 'should contain class r10k' do
          should contain_class('r10k').with({
            :version => 'installed'
          })
        end
      #   # it 'should contain puppet_r10k cron' do
      #   #   should contain_cron('puppet_r10k').with({
      #   #     :ensure      => true,
      #   #     :command     => "r10k deploy environment production -p",
      #   #     :environment => 'PATH=/usr/local/bin:/bin:/usr/bin:/usr/sbin',
      #   #     :user        => true,
      #   #     :minute      => [0,15,30,45],
      #   #   })
      #   # end
      end#no params

      # context 'when given webhook configurations' do
      #   let(:params) do
      #     {
      #       :r10k => {
      #         :webhook  => {
      #           :config => {
      #             :ensure => 'present',
      #             :use_mcollective => false,
      #             :public_key_path => '/etc/mcollective/server_public.pem',
      #             :private_key_path => '/etc/mcollective/server_private.pem'
      #           }
      #         }
      #       }
      #     }
      #   end
      #   it 'should contain classes r10k::webhook and r10k::webhook::config' do
      #     should contain_class('r10k::webhook::config').with({
      #       :ensure => 'present',
      #       :use_mcollective => false,
      #       :public_key_path => '/etc/mcollective/server_public.pem',
      #       :private_key_path => '/etc/mcollective/server_private.pem'
      #     })
      #   end
      # end

    end
  end
end
