# == Define: diamond::collector
#
# A puppet wrapper for the collector files
#
# === Parameters
# [*options*]
#   Options for use the the collector template
#
define diamond::collector (
  $options = undef
) {

  file {"/etc/diamond/collectors/${name}.conf":
    content => template('diamond/etc/diamond/collectors/collector.conf.erb')
  }
}
