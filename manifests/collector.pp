# == Define: diamond::collector
#
# A puppet wrapper for the collector files
#
# === Parameters
# [*options*]
#   Options for use the the collector template
#
# [*sections*]
#   Some collectors have multiple sections, for example the netapp and rabbitmq collectors
#   Each section can have its own options
define diamond::collector (
  $options = undef,
  $sections = undef
) {
  include diamond

  Class['diamond::config']
  ->
  file {"/etc/diamond/collectors/${name}.conf":
    content => template('diamond/etc/diamond/collectors/collector.conf.erb')
  }
  ~>
  Class['diamond::service']
}

