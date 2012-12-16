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
class diamond(
  $version = 'present',
  $enable = true,
  $start = true,
  $interval = 30,
  $host = 'localhost',
) {
  class{'diamond::install': } ->
  class{'diamond::config': } ~>
  class{'diamond::service': } ->
  Class['diamond']
}
