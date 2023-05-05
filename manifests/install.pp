# == Class: diamond::install
#
# Class to install Diamond from packages.
# Also installed dependencies for collectors
#
class diamond::install {

  if $diamond::install_from_pip {
    case $::osfamily {
      'RedHat': {
        include epel
        ensure_resource('package', 'python-pip', {'ensure' => 'present', 'before' => Package['diamond'], 'require' => Yumrepo['epel']})
        ensure_resource('package', ['python-configobj','gcc','python-devel'], {'ensure' => 'present', 'before' => Package['diamond'], 'require' => Package['python-pip']})
      }
      /^(Debian|Ubuntu)$/: {
        ensure_resource('package', ['python-pip','python-configobj','gcc','python-dev'], {'ensure' => 'present'})
      }
      'Solaris': {
        case $::kernelrelease {
          '5.11': {
            ensure_resource('package', ['pip','solarisstudio-122'], {'ensure' => 'present', 'before' => Package['diamond']})
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
      default: { fail('Unrecognized operating system') }
    }
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
    if $::diamond::service_provider == 'upstart' {
        file {
            '/etc/init/diamond.conf':
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                content => template('diamond/ubuntu/upstart/diamond.conf.erb');
            '/etc/init.d/diamond':
                target  => '/lib/init/upstart-job';
        }
    } elsif $::diamond::service_provider == 'systemd' {
        file {
            '/etc/tmpfiles.d/diamond.conf':
                owner   => 'root',
                group   => 'root',
                mode    => '0444',
                source  => 'puppet:///modules/diamond/etc/tmpfiles.d/diamond.conf';
            '/lib/systemd/system/diamond.service':
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                source  => 'puppet:///modules/diamond/lib/systemd/system/diamond.service';
        }
    } else {
        file { '/etc/init.d/diamond':
            mode    => '0755',
            require => Package['diamond'],
        }
    }
  }
  file { '/var/log/diamond':
    owner   => $::diamond::user,
    ensure => directory,
  }
} else {
  package { 'diamond':
    ensure  => $diamond::version,
  }
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

  $::diamond::collector_paths.each |$path| {
    ensure_resource('exec', "create $path", { 'command' => "mkdir -p ${path}", 'creates' => $path })
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
