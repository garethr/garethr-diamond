class diamond::config {
  $host = $diamond::host
  $interval = $diamond::interval
  $librato_user = $diamond::librato_user
  $librato_apikey = $diamond::librato_apikey
  file { '/etc/diamond/diamond.conf':
    ensure  => present,
    content => template('diamond/etc/diamond/diamond.conf'),
  }
}
