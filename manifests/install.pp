class diamond::install {
  package { 'diamond':
    ensure  => $diamond::version,
    require => Class['garethr'],
  }
  file { '/var/run/diamond':
    ensure => directory,
  }
}
