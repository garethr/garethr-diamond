# == Class: diamond::service
#
# Class representing the Diamond service
#
class diamond::service {
  $ensure = $diamond::start ? {true => running, default => stopped}
  $service_name   = $::osfamily ? {
    'Solaris' => 'network/diamond',
    default   => 'diamond',
  }
  $manifest = $::osfamily ? {
    'Solaris' => '/lib/svc/manifest/network/diamond.xml',
    default   => undef,
  }
  $provider = $::systemd_available ? {
    'true'  => 'systemd',
    default => undef,
  }

  service { 'diamond':
    ensure     => $ensure,
    provider   => $provider,
    name       => $service_name,
    enable     => $diamond::enable,
    hasstatus  => true,
    hasrestart => true,
    manifest   => $manifest,
  }
}

