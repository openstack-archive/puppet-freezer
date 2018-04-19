require 'spec_helper'

describe 'freezer::config' do

  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples_for 'freezer_config' do
    let :params do
      { :freezer_config => config_hash }
    end

    it { is_expected.to contain_class('freezer::deps') }

    it 'configures arbitrary freezer-config configurations' do
      is_expected.to contain_freezer_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_freezer_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_freezer_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'freezer_api_paste_ini' do
    let :params do
      { :api_paste_ini_config => config_hash }
    end

    it 'configures arbitrary freezer-api-paste-ini configurations' do
      is_expected.to contain_freezer_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_freezer_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_freezer_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'freezer_config'
      it_configures 'freezer_api_paste_ini'
    end
  end
end
