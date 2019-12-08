#
# Class to execute freezer-manage db sync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the freezer-manage db sync command. These will be inserted
#   in the command line between 'freezer-manage' and 'db sync'.
#   Defaults to undef
#
class freezer::db::sync(
  $extra_params  = undef,
) {

  include freezer::deps

  exec { 'freezer-db-sync':
    command     => "freezer-manage ${extra_params} db sync",
    path        => [ '/usr/local/bin/', '/usr/bin', ],
    user        => 'freezer',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['freezer::install::end'],
      Anchor['freezer::config::end'],
      Anchor['freezer::dbsync::begin']
    ],
    notify      => Anchor['freezer::dbsync::end'],
    tag         => 'openstack-db',
  }
}
