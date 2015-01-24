# == Class: diamond::install
#
# Class to install Diamond from packages.
# Also installed dependencies for collectors
#
class diamond::install {

  if $diamond::install_from_pip {
    package {'diamond':
      ensure   => present,
      provider => pip,
    }
    if $::osfamily == 'Solaris' {
      # This should eventually go upstream
      file { '/lib/svc/method/diamond':
        source  => 'puppet:///modules/diamond/solaris/method/diamond',
        mode    => '0755',
        owner   => 'root',
        group   => 'bin',
        require => Package['diamond'],
      }
      file { '/lib/svc/manifest/network/diamond.xml':
        source  => 'puppet:///modules/diamond/solaris/manifest/diamond.xml',
        mode    => '0444',
        owner   => 'root',
        group   => 'sys',
        require => [Package['diamond'],File['/lib/svc/method/diamond']],
      }
    } else {
      file { '/etc/init.d/diamond':
        mode    => '0755',
        require => Package['diamond'],
      }
    }
    file { '/var/log/diamond':
      ensure => directory,
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
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { '/etc/diamond/collectors':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    purge   => $diamond::purge_collectors,
    recurse => true,
    require => File['/etc/diamond'],
  }

  if $diamond::librato_user and $diamond::librato_apikey {
    ensure_resource('package',
      'librato-metrics', {
        'ensure'   => 'present',
        'provider' => pip,
        'before'   => Package['python-pip']
      }
    )
  }

  if $diamond::riemann_host {
    ensure_resource('package',
      'bernhard', {
        'ensure'   => 'present',
        'provider' => pip,
        'before'   => Package['python-pip']
      }
    )
  }

}
