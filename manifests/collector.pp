define diamond::collector (
  $options = undef
) {

  file {"/etc/diamond/collectors/${name}.conf":
    content => template('diamond/etc/diamond/collectors/collector.conf.erb')
  }
}
