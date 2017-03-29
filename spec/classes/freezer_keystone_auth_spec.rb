#
# Unit tests for freezer::keystone::auth
#

require 'spec_helper'

describe 'freezer::keystone::auth' do
  shared_examples_for 'freezer-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'freezer_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('freezer').with(
        :ensure   => 'present',
        :password => 'freezer_password',
      ) }

      it { is_expected.to contain_keystone_user_role('freezer@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('freezer::backup').with(
        :ensure      => 'present',
        :description => 'OpenStack distributed backup restore and disaster recovery as a service platform'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/freezer::backup').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9090',
        :admin_url    => 'http://127.0.0.1:9090',
        :internal_url => 'http://127.0.0.1:9090',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'freezer_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/freezer::backup').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'freezery' }
      end

      it { is_expected.to contain_keystone_user('freezery') }
      it { is_expected.to contain_keystone_user_role('freezery@services') }
      it { is_expected.to contain_keystone_service('freezer::backup') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/freezer::backup') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'freezer_service',
          :auth_name    => 'freezer',
          :password     => 'freezer_password' }
      end

      it { is_expected.to contain_keystone_user('freezer') }
      it { is_expected.to contain_keystone_user_role('freezer@services') }
      it { is_expected.to contain_keystone_service('freezer_service::backup') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/freezer_service::backup') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'freezer_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('freezer') }
      it { is_expected.to contain_keystone_user_role('freezer@services') }
      it { is_expected.to contain_keystone_service('freezer::backup').with(
        :ensure      => 'present',
        :description => 'OpenStack distributed backup restore and disaster recovery as a service platform'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'freezer_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('freezer') }
      it { is_expected.not_to contain_keystone_user_role('freezer@services') }
      it { is_expected.to contain_keystone_service('freezer::backup').with(
        :ensure      => 'present',
        :description => 'OpenStack distributed backup restore and disaster recovery as a service platform'
      ) }

    end

    context 'when using ensure absent' do

      let :params do
        {
          :password => 'freezer_password',
          :ensure   => 'absent'
        }
      end

      it { is_expected.to contain_keystone__resource__service_identity('freezer').with_ensure('absent') }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'freezer-keystone-auth'
    end
  end
end
