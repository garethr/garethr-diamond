class diamond::config {
  $host = $diamond::host
  $interval = $diamond::interval
  file { '/etc/diamond/diamond.conf':
    ensure  => present,
    content => template('diamond/etc/diamond/diamond.conf'),
  }
}
