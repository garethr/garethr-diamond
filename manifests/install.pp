# == Class: diamond::install
#
# Class to install Diamond from packages.
# Also installed dependencies for collectors
#
class diamond::install {
  
  if $diamond::install_from_pip {
   case $operatingsystem {
     'RedHat': { $pythondev = "python-devel" }
     /^(Debian|Ubuntu)$/: { $pythondev = "python-dev" }
     'default': { fail("Unrecognized operating system") }
   }
   ensure_packages(['python-pip','gcc',$pythondev], {'ensure' => 'present', 'before' => Package['diamond']})
   ensure_packages(['diamond'], {'ensure' => 'present', 'provider' => pip})
   file { "/etc/init.d/diamond":
   mode => 755,
   require => Package['diamond'],
   }
} else {
  package { 'diamond':
    ensure  => $diamond::version,
  }
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
