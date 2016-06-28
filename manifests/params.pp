# == Class: diamond::params
#
# Default parameter values for the diamond module
#
class diamond::params {
  $version           = 'present'
  $enable            = true
  $start             = true
  $interval          = 30
  $librato_user      = false
  $librato_apikey    = false
  $graphite_host     = false
  $graphite_handler  = 'graphite.GraphiteHandler'
  $graphite_port     = '2003'
  $graphite_protocol = 'TCP'
  $pickle_port       = '2004'
  $riemann_host      = false
  $stats_host        = '127.0.0.1'
  $stats_port        = 8125
  $path_prefix       = undef
  $path_suffix       = undef
  $instance_prefix   = undef
  $logger_level      = 'WARNING'
  $rotate_level      = 'WARNING'
  $rotate_days       = 7
  $extra_handlers    = []
  $server_hostname   = undef
  $hostname_method   = undef
  $handlers_path     = undef
  $purge_collectors  = false
  $install_from_pip  = false

  case $::osfamily {
    'Archlinux': {
      $diamond_path = '/usr/bin/diamond'
      $collectors_path = '/usr/share/diamond/collectors'
    }
    'RedHat': {
      $diamond_path = '/usr/bin/diamond'
      $collectors_path = '/usr/share/diamond/collectors'
    }
    'Debian': {
      $diamond_path = '/usr/local/bin/diamond'
      $collectors_path = '/usr/local/share/diamond/collectors'
    }
    'Solaris': {
      $diamond_path = '/usr/bin/diamond'
      $collectors_path = '/usr/share/diamond/collectors'
      $provider = undef
    }
    default: {
      $diamond_path = '/usr/bin/diamond'
      $collectors_path = '/usr/share/diamond/collectors'
      $provider = undef
    }
  }
}
