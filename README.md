A Puppet module for managing the installation and configuration of
[Diamond](https://github.com/BrightcoveOS/Diamond).

[![Puppet
Forge](http://img.shields.io/puppetforge/v/garethr/diamond.svg)](https://forge.puppetlabs.com/garethr/diamond) [![Build
Status](https://secure.travis-ci.org/garethr/garethr-diamond.png)](http://travis-ci.org/garethr/garethr-diamond)

# Usage

For experimenting you're probably fine just with:

```puppet
include diamond
```

This installs diamond but doesn't ship the metrics anywhere, it just
runs the archive handler.

## Configuration

This module currently exposes a few configurable options, for example 
the Graphite host and polling interval. So you can also do:

```puppet
class { 'diamond':
  graphite_host => 'graphite.example.com',
  graphite_port => 2013,
  interval      => 10,
}
```

You can also add additional collectors:

```puppet
diamond::collector { 'RedisCollector':
  options => {
    'instances' => 'main@localhost:6379, other@localhost:6380'
  }
}
```

Some collectors support multiple sections, for example the NetApp and RabbitMQ collectors

```puppet
diamond::collector { 'NetAppCollector':
  options => {
    'path_prefix' => '/opt/netapp/lib/python'
  },
  sections => {
    '[devices]' => {},
    '[[host01]]' => {
         'ip' => '10.10.10.1',
         'username' => 'bob',
         'password' => 'alice'
    },
    '[[host02]]' => {
         'ip' => '10.10.10.2',
         'username' => 'alice',
         'password' => 'bob'
    }
  }
}

diamond::collector { 'RabbitMQCollector':
  options => {
    'host' => '10.10.10.1',
    'user' => 'bob',
    'password' => 'alice'
  },
  sections => {
    '[vhosts]' => {
      '*' => '*'
    }
  }
}
```

Diamond supports a number of different handlers, for the moment this
module supports only the Graphite, Librato and Riemann handers. Pull request
happily accepted to add others.

With Librato:

```puppet
class { 'diamond':
  librato_user   => 'bob',
  librato_apikey => 'jim',
}
```

With Riemann:

```puppet
class { 'diamond':
  riemann_host => 'riemann.example.com',
}
```

Note that you can include more than one of these at once.

```puppet
class { 'diamond':
  librato_user   => 'bob',
  librato_apikey => 'jim',
  riemann_host   => 'riemann.example.com',
  graphite_host  => 'graphite.example.com',
}
```
