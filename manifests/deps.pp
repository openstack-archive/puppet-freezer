# == Class: freezer::deps
#
#  Freezer anchors and dependency management
#
class freezer::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'freezer::install::begin': }
  -> Package<| tag == 'freezer-package'|>
  ~> anchor { 'freezer::install::end': }
  -> anchor { 'freezer::config::begin': }
  -> Freezer_config<||>
  ~> anchor { 'freezer::config::end': }
  -> anchor { 'freezer::db::begin': }
  -> anchor { 'freezer::db::end': }
  ~> anchor { 'freezer::dbsync::begin': }
  -> anchor { 'freezer::dbsync::end': }
  ~> anchor { 'freezer::service::begin': }
  ~> Service<| tag == 'freezer-service' |>
  ~> anchor { 'freezer::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['freezer::dbsync::begin']

  # Installation or config changes will always restart services.
  Anchor['freezer::install::end'] ~> Anchor['freezer::service::begin']
  Anchor['freezer::config::end']  ~> Anchor['freezer::service::begin']
}
