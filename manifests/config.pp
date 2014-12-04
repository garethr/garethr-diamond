# == Class: diamond::config
#
# The configuration of the Diamond daemon
#
class diamond::config {
  $interval         = $diamond::interval
  $graphite_host    = $diamond::graphite_host
  $graphite_port    = $diamond::graphite_port
  $graphite_handler = $diamond::graphite_handler
  $pickle_port      = $diamond::pickle_port
  $riemann_host     = $diamond::riemann_host
  $librato_user     = $diamond::librato_user
  $librato_apikey   = $diamond::librato_apikey
  $path_prefix      = $diamond::path_prefix
  $path_suffix      = $diamond::path_suffix
  $instance_prefix  = $diamond::instance_prefix
  $logger_level     = $diamond::logger_level
  $rotate_level     = $diamond::rotate_level
  $server_hostname  = $diamond::server_hostname
  $hostname_method  = $diamond::hostname_method
  $handlers_path    = $diamond::handlers_path
  $rotate_days      = $diamond::rotate_days
  file { '/etc/diamond/diamond.conf':
    ensure  => present,
    content => template('diamond/etc/diamond/diamond.conf.erb'),
  }
}
