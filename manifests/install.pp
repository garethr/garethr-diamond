# == Class: diamond::install
#
# Class to install Diamond from packages.
# Also installed dependencies for collectors
#
class diamond::install {

  if $diamond::install_from_pip {
    case $::osfamily {
      Solaris: {
        case $::operatingsystemrelease {
          '5.11': {
            package { 'solarisstudio-122':
              ensure => present,
              before => Package['diamond'],
            }
            file { ['/ws', '/ws/on11update-tools', '/ws/on11update-tools/SUNWspro']: ensure => directory, }
            file { '/ws/on11update-tools/SUNWspro/sunstudio12.1':
              ensure  => symlink,
              force   => true,
              target  => '/opt/solstudio12.2',
              before  => Package['diamond'],
              require => Package['solarisstudio-122'],
            }
          }
          default: {
            fail('Module only supports version 11 when used on Solaris')
          }
        }
      }
    }
    package { 'diamond':
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
    # This package should be handled outside of our module, currently no module
    # on the forge manages the resource so we'll let it slide
    package { 'librato-metrics':
      ensure   => present,
      provider => pip,
    }
  }

  if $diamond::riemann_host {
    # This package should be handled outside of our module, currently no module
    # on the forge manages the resource so we'll let it slide
    package { 'bernhard':
      ensure   => present,
      provider => pip,
    }
  }

}
