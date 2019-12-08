# == Class: freezer::keystone::auth
#
# Configures freezer user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for freezer user.
#
# [*ensure*]
#   (Optional) Ensure state of keystone service identity.
#   Defaults to 'present'.
#
# [*auth_name*]
#   (Optional) Username for freezer service.
#   Defaults to 'freezer'.
#
# [*email*]
#   (Optional) Email for freezer user.
#   Defaults to 'freezer@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for freezer user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should freezer endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'backup'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of 'freezer'.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'OpenStack distributed backup restore and disaster recovery as a service platform'
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9090'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9090'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:9090'
#
class freezer::keystone::auth (
  $password,
  $ensure              = 'present',
  $auth_name           = 'freezer',
  $email               = 'freezer@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'freezer',
  $service_description = 'OpenStack distributed backup restore and disaster recovery as a service platform',
  $service_type        = 'backup',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9090',
  $admin_url           = 'http://127.0.0.1:9090',
  $internal_url        = 'http://127.0.0.1:9090',
) {

  include freezer::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'freezer-server' |>
  }
  Keystone_endpoint["${region}/${service_name}::${service_type}"]  ~> Service <| name == 'freezer-server' |>

  keystone::resource::service_identity { 'freezer':
    ensure              => $ensure,
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
