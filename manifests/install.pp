# == Class: diamond::install
#
# Class to install Diamond from packages.
# Also installed dependencies for collectors
#
class diamond::install {
  $diamond_path = $diamond::diamond_path

  if $diamond::install_from_pip {
    case $::osfamily {
      'RedHat': {
        include epel
        if $diamond::manage_pip {
          ensure_resource('package', 'python-pip', {'ensure' => 'present', 'before' => Python::Pip['diamond'], 'require' => Yumrepo['epel']})
        }
        if $diamond::manage_build_deps {
          ensure_resource('package', ['python-configobj','gcc','python-devel'], {'ensure' => 'present', 'before' => Python::Pip['diamond'], 'require' => Package['python-pip']})
        }
      }
      /^(Debian|Ubuntu)$/: {
        if $diamond::manage_pip {
          ensure_resource('package', 'python-pip', {'ensure' => 'present', 'before' => Python::Pip['diamond']})
        }
        if $diamond::manage_build_deps {
          ensure_resource('package', ['python-configobj','gcc','python-dev'], {'ensure' => 'present', 'before' => Python::Pip['diamond']})
        }
      }
      'Solaris': {
        case $::kernelrelease {
          '5.11': {
            if $diamond::manage_pip {
              ensure_resource('package', 'pip', {'ensure' => 'present', 'before' => Python::Pip['diamond']})
            }
            if $diamond::manage_build_deps {
              ensure_resource('package', 'solarisstudio-122', {'ensure' => 'present', 'before' => Python::Pip['diamond']})
              file { ['/ws', '/ws/on11update-tools', '/ws/on11update-tools/SUNWspro']: ensure => directory, }
              file { '/ws/on11update-tools/SUNWspro/sunstudio12.1':
                ensure  => symlink,
                force   => true,
                target  => '/opt/solstudio12.2',
                before  => Python::Pip['diamond'],
                require => Package['solarisstudio-122'],
              }
            }
          }
          default: {
            fail('Module only supports version 11 when used on Solaris')
          }
        }
      }
      default: { fail('Unrecognized operating system') }
    }
  ::python::pip { 'diamond':
    ensure => present,
    proxy  => $diamond::pip_proxy,
  }
  if $::osfamily == 'Solaris' {
    # This should eventually go upstream
    file { '/lib/svc/method/diamond':
      source  => 'puppet:///modules/diamond/solaris/method/diamond',
      mode    => '0755',
      owner   => 'root',
      group   => 'bin',
      require => Python::Pip['diamond'],
    }
    file { '/lib/svc/manifest/network/diamond.xml':
      source  => 'puppet:///modules/diamond/solaris/manifest/diamond.xml',
      mode    => '0444',
      owner   => 'root',
      group   => 'sys',
      require => [Python::Pip['diamond'],File['/lib/svc/method/diamond']],
    }
  }

  if $::systemd {
    ::systemd::unit_file { "diamond.service":
      content => template('diamond/diamond.service.erb'),
      before  => Service['diamond'],
    }
  } else {
    file { '/etc/init.d/diamond':
      mode    => '0755',
      require => Python::Pip['diamond'],
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
    if $diamond::manage_pip {
      ensure_packages(['python-pip'])
    }
    ensure_resource('package', 'librato-metrics', {'ensure' => 'present', 'provider' => pip, 'before' => Package['python-pip']})
  }

  if $diamond::riemann_host {
    if $diamond::manage_pip {
      ensure_packages(['python-pip'])
    }
    ensure_resource('package', 'bernhard', {'ensure' => 'present', 'provider' => pip, 'before' => Package['python-pip']})
  }
}
