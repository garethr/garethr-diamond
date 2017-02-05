# == Class: diamond::service
#
# Class representing the Diamond service
#
class diamond::service {
  $ensure   = $::diamond::start ? {true => running, default => stopped}
  $provider = $::diamond::service_provider
  $service_name   = $::osfamily ? {
    'Solaris' => 'network/diamond',
    default   => 'diamond',
  }
  $manifest = $::osfamily ? {
    'Solaris' => '/lib/svc/manifest/network/diamond.xml',
    default   => undef,
  }
  if $provider == 'upstart' {
    file {
        '/etc/init/diamond.conf':
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            source  => 'puppet:///modules/diamond/debain/upstart/diamond.conf';
        '/etc/init.d/diamond':
            target  => '/lib/init/upstart-job';
    }
  }
  service { 'diamond':
    ensure     => $ensure,
    name       => $service_name,
    enable     => $::diamond::enable,
    hasstatus  => true,
    hasrestart => true,
    manifest   => $manifest,
    provider   => $provider,
  }
}

