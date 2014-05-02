# == Class: diamond::config
#
# The configuration of the Diamond daemon
#
class diamond::config {
  $interval         = $diamond::interval
  $graphite_host    = $diamond::graphite_host
  $graphite_handler = $diamond::graphite_handler
  $riemann_host     = $diamond::riemann_host
  $librato_user     = $diamond::librato_user
  $librato_apikey   = $diamond::librato_apikey
  $path_prefix      = $diamond::path_prefix
  $path_suffix      = $diamond::path_suffix
  $handlers_path    = $diamond::handlers_path

  file { '/etc/diamond/collectors':
    ensure  => directory,
    purge   => true,
    recurse =>  true,
  }

  file { '/etc/diamond/diamond.conf':
    ensure  => present,
    content => template('diamond/etc/diamond/diamond.conf.erb'),
  }
}
