#
# Class to execute freezer-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the freezer-dbsync command.
#   Defaults to undef
#
class freezer::db::sync(
  $extra_params  = undef,
) {
  exec { 'freezer-db-sync':
    command     => "freezer-manage db_sync ${extra_params}",
    path        => [ '/bin', '/usr/bin', ],
    user        => 'freezer',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [Package['freezer'], Freezer_config['database/connection']],
  }

  Exec['freezer-manage db_sync'] ~> Service<| title == 'freezer' |>
}
