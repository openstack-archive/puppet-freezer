# == Class: freezer::config
#
# This class is used to manage arbitrary freezer configurations.
#
# === Parameters
#
# [*freezer_config*]
#   (optional) Allow configuration of arbitrary freezer configurations.
#   The value is an hash of freezer_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   freezer_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*freezer_config*]
#   (optional) Allow configuration of freezer.conf configurations.
#   Defaults to empty hash'{}'
#
# [*api_paste_ini_config*]
#   (optional) Allow configuration of /etc/freezer/freezer-paste.ini configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class freezer::config (
  $freezer_config = {},
  $api_paste_ini_config  = {},
) {

  include ::freezer::deps

  validate_hash($freezer_config)
  validate_hash($api_paste_ini_config)

  create_resources('freezer_config', $freezer_config)
  create_resources('freezer_api_paste_ini', $api_paste_ini_config)
}
