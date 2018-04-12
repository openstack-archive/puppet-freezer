require 'spec_helper'

describe 'freezer::client' do

  shared_examples 'freezer client' do
    it { is_expected.to contain_class('freezer::params') }
    it { is_expected.to contain_package('python-freezerclient').with(
        :name     => platform_params[:client_package_name],
        :ensure   => 'present',
        :tag      => ['openstack', 'freezer-support-package'],
        :provider => 'pip',
      )
    }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:os_package_type] == 'debian'
            { :client_package_name => 'python3-freezerclient' }
          else
            { :client_package_name => 'python-freezerclient' }
          end
        when 'RedHat'
          { :client_package_name => 'python-freezerclient' }
        end
      end

      it_configures 'freezer client'
    end
  end
end
