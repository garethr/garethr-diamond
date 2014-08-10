# == Class: diamond::install
#
# Class to install Diamond from packages.
# Also installed dependencies for collectors
#
class diamond::install {
  package { 'diamond':
    ensure  => $diamond::version,
  }
  file { '/var/run/diamond':
    ensure => directory,
  }

  file { '/etc/diamond':
    ensure  => directory,
    owner   => root,
    group   => root,
  }

  file { '/etc/diamond/collectors':
    ensure  => directory,
    owner   => root,
    group   => root,
    purge   => $diamond::purge_collectors,
    recurse => true,
    require => File['/etc/diamond'],
  }

  if $diamond::librato_user and $diamond::librato_apikey {
    ensure_packages(['python-pip'])
    ensure_resource('package', 'librato-metrics', {'ensure' => 'present', 'provider' => pip, 'before' => Package['python-pip']})
  }

  if $diamond::riemann_host {
    ensure_packages(['python-pip'])
    ensure_resource('package', 'bernhard', {'ensure' => 'present', 'provider' => pip, 'before' => Package['python-pip']})
  }

}
