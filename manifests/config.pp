class diamond::config {
  $interval = $diamond::interval
  $graphite_host = $diamond::graphite_host
  $riemann_host = $diamond::riemann_host
  $librato_user = $diamond::librato_user
  $librato_apikey = $diamond::librato_apikey
  file { '/etc/diamond/diamond.conf':
    ensure  => present,
    content => template('diamond/etc/diamond/diamond.conf'),
  }
}
