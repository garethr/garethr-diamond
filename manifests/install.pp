class diamond::install {
  package { 'diamond':
    ensure  => $diamond::version,
    require => Class['garethr'],
  }
}
