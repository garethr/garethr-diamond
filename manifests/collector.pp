define diamond::collector (
  $options
) {

  file {"/etc/diamond/collectors/${name}.conf":
    content => template('diamond/etc/diamond/collectors/collector.conf.erb')
  }
}
