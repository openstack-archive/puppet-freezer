# == Class: freezer::db::postgresql
#
# Class that configures postgresql for freezer
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'freezer'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'freezer'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class freezer::db::postgresql(
  $password,
  $dbname     = 'freezer',
  $user       = 'freezer',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include freezer::deps

  ::openstacklib::db::postgresql { 'freezer':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['freezer::db::begin']
  ~> Class['freezer::db::postgresql']
  ~> Anchor['freezer::db::end']

}
