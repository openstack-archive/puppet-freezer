# Parameters for puppet-freezer
#
class freezer::params {
  include openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers

  $api_deploy_method  = 'apache'
  $api_bind_port      = '9090'
  $client_package     = "python${pyvers}-freezerclient"
  $freezer_db_backend = 'elasticsearch'
  $db_sync_command    = 'freezer-manage db sync'
  $group              = 'freezer'

# TODO: vnogin
# Test Freezer API wsgi app in Apache
# $freezer_wsgi_script_source = '/usr/bin/freezer-wsgi'

  case $::osfamily {
    'RedHat': {
      $api_package_name            = 'freezer-api'
      $scheduler_package_name      = 'freezer'
      $freezer_web_ui_package_name = 'freezer-web-ui'
    }
    'Debian': {
      $api_package_name            = 'freezer-api'
      $scheduler_package_name      = 'freezer'
      $freezer_web_ui_package_name = 'freezer-web-ui'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }

  } # Case $::osfamily
}
