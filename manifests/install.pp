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
}
