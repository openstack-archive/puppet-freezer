# The freezer::db::mysql class implements mysql backend for freezer
#
# This class can be used to create tables, users and grant
# privilege for a mysql freezer database.
#
# == Parameters
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
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
class freezer::db::mysql(
  $password,
  $dbname        = 'freezer',
  $user          = 'freezer',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef
) {

  include ::freezer::deps

  validate_string($password)

  ::openstacklib::db::mysql { 'freezer':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['freezer::db::begin']
  ~> Class['freezer::db::mysql']
  ~> Anchor['freezer::db::end']

}
