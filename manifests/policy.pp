# == Class: freezer::policy
#
# Configure the freezer policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for freezer
#   Example :
#     {
#       'freezer-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'freezer-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.yaml file
#   Defaults to /etc/freezer/policy.yaml
#
class freezer::policy (
  $policies    = {},
  $policy_path = '/etc/freezer/policy.yaml',
) {

  include freezer::deps
  include freezer::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::freezer::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'freezer_config': policy_file => $policy_path }

}
