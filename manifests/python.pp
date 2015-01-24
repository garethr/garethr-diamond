# == Class: diamond::python
#
# Class to install python-pip and dependencies
#
class diamond::python {
  if $diamond::manage_python {
    case $::osfamily {
      /^(RedHat|Debian)$/: {
        include epel # epel does nothing on Debian/Ubuntu
        class { '::python':
          pip     => true,
          dev     => true,
          require => Class['epel']
        }
        ensure_resource('package', 'gcc', {
            'ensure'  => 'present',
            'require' => Class['::python'],
          }
        )
      }
      Solaris: {
        case $::operatingsystemrelease {
          '5.11': {
            ensure_resource('package',
              ['pip','solarisstudio-122'], {
                'ensure' => 'present',
                'before' => Package['diamond']
              }
            )
            $dirs = [
              '/ws',
              '/ws/on11update-tools',
              '/ws/on11update-tools/SUNWspro'
            ]
            file { $dirs: ensure => directory, }
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
      default: { fail("${::osfamily} is an unrecognized operating system") }
    }
  }
}
