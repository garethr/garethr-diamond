# == Class: diamond
#
# A basic module to manage diamond, stats collection daemon for Graphite
#
# === Parameters
# [*version*]
#   The package version to install
#
# [*enable*]
#   Should the service be enabled during boot time?
#
# [*start*]
#   Should the service be started by Puppet
#
# [*interval*]
#   How often should metrics be collected and sent to Graphite
#
# [*host*]
#   Where to find the graphite server
#
# [*librato_user*]
#   How often should metrics be collected and sent to Graphite
#
# [*librato_apikey*]
#   Where to find the graphite server
#
class diamond(
  $version = 'present',
  $enable = true,
  $start = true,
  $interval = 30,
  $librato_user = false,
  $librato_apikey = false,
  $host = 'localhost',
) {
  class{'diamond::install': } ->
  class{'diamond::config': } ~>
  class{'diamond::service': } ->
  Class['diamond']
}
