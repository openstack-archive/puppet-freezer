require 'spec_helper'

describe 'freezer::db::postgresql' do

  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    { :password => 'freezerpass' }
  end

  shared_examples_for 'freezer-db-postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('freezer::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('freezer').with(
        :user       => 'freezer',
        :password   => 'freezerpass',
        :dbname     => 'freezer',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      it_behaves_like 'freezer-db-postgresql'
    end
  end
end
