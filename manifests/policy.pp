# == Class: freezer::policy
#
# Configure the freezer policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for freezer
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
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/freezer/policy.json
#
class freezer::policy (
  $policies    = {},
  $policy_path = '/etc/freezer/policy.json',
) {

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path => $policy_path,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'freezer_config': policy_file => $policy_path }

}
