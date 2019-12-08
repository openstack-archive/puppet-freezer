#
# Installs the glance python library.
#
# == parameters
#  [*ensure*]
#    (Optional) Ensure state for pachage.
#    Defaults to 'present'
#
class freezer::client(
  $ensure = 'present'
) {

  include freezer::deps
  include freezer::params

  package { 'python-freezerclient':
    ensure   => $ensure,
    name     => $::freezer::params::client_package,
    tag      => ['openstack', 'freezer-support-package'],
# TODO: vnogin
# Provider should be removed when deb and rpm packages are available
    provider => 'pip',
  }

}
