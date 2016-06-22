# == Class: diamond
#
# A basic module to manage diamond, stats collection daemon for Graphite
#
# === Parameters
# [*version*]
#   The package version to install
#
# [*enable*]
#   Should the service be enabled during boot time?
#
# [*start*]
#   Should the service be started by Puppet
#
# [*interval*]
#   How often should metrics be collected and sent to Graphite
#
# [*extra_handlers*]
#   Additional handlers to include in configuration
#
# [*graphite_host*]
#   Where to find the graphite server
#
# [*graphite_handler*]
#   Which handler to use to talk with graphite server
#
# [*graphite_protocol*]
#   Which protocol to use to talk with graphite server
#
# [*stats_host*]
#   Where to find the stats server
#
# [*stats_port*]
#   What port to connect to the stats server
#
# [*librato_user*]
#   Your Librato username
#
# [*librato_apikey*]
#   Your Librato apikey
#
# [*riemann_host*]
#   Where to find the riemann server
#
# [*path_prefix*]
#   Define optional path_prefix for storing metrics
#
# [*path_suffix*]
#   Define optional path_suffix for storing metrics
#
# [*instance_prefix*]
#   Define optional instance_prefix for storing instance metrics
#
# [*handlers_path*]
#   Define optional handlers_path for custom handlers
#
# [*purge_collectors*]
#   Determine if we should purge collectors Puppet does not manage
#
# [*install_from_pip*]
#   Determine if we should install diamond from python-pip
#
# [*rotate_days*]
#   Number of days of rotate logs to keep
#
class diamond(
  $version           = $diamond::params::version,
  $enable            = $diamond::params::enable,
  $start             = $diamond::params::start,
  $interval          = $diamond::params::interval,
  $librato_user      = $diamond::params::librato_user,
  $librato_apikey    = $diamond::params::librato_apikey,
  $graphite_host     = $diamond::params::graphite_host,
  $graphite_handler  = $diamond::params::graphite_handler,
  $graphite_port     = $diamond::params::graphite_port,
  $graphite_protocol = $diamond::params::graphite_protocol,
  $pickle_port       = $diamond::params::pickle_port,
  $riemann_host      = $diamond::params::riemann_host,
  $stats_host        = $diamond::params::stats_host,
  $stats_port        = $diamond::params::stats_port,
  $path_prefix       = $diamond::params::path_prefix,
  $path_suffix       = $diamond::params::path_suffix,
  $instance_prefix   = $diamond::params::instance_prefix,
  $logger_level      = $diamond::params::logger_level,
  $rotate_level      = $diamond::params::rotate_level,
  $rotate_days       = $diamond::params::rotate_days,
  $extra_handlers    = $diamond::params::extra_handlers,
  $server_hostname   = $diamond::params::server_hostname,
  $hostname_method   = $diamond::params::hostname_method,
  $handlers_path     = $diamond::params::handlers_path,
  $purge_collectors  = $diamond::params::purge_collectors,
  $install_from_pip  = $diamond::params::install_from_pip,
  $manage_pip        = $diamond::params::manage_pip,
  $manage_build_deps = $diamond::params::manage_build_deps,
) inherits diamond::params {
  class{'diamond::install': } ->
  class{'diamond::config': } ~>
  class{'diamond::service': } ->
  Class['diamond']
}
