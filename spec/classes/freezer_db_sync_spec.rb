require 'spec_helper'

describe 'freezer::db::sync' do

  shared_examples_for 'freezer-dbsync' do

    it 'runs freezer-db-sync' do
      is_expected.to contain_exec('freezer-db-sync').with(
        :command     => 'freezer-manage db_sync ',
        :path        => [ '/bin', '/usr/bin', ],
        :refreshonly => 'true',
        :user        => 'freezer',
        :logoutput   => 'on_failure'
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'freezer-dbsync'
    end
  end

end
