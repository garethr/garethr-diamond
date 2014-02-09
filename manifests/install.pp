# == Class: diamond::install
#
# Class to install Diamond from packages
#
class diamond::install {
  package { 'diamond':
    ensure  => $diamond::version,
  }
  file { '/var/run/diamond':
    ensure => directory,
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
