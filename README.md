A Puppet module for managing the installation and configuration of
[Diamond](https://github.com/BrightcoveOS/Diamond).

[![Build
Status](https://secure.travis-ci.org/garethr/garethr-diamond.png)](http://travis-ci.org/garethr/garethr-diamond)

# Usage

For experimenting you're probably fine just with:

    include diamond

This installs diamond but doesn't ship the metrics anywhere, it just
runs the archive handler.

## Configuration

This module currently exposes a few configurable options, for example 
the Graphite host and polling interval. So you can also do:

    class { 'diamond':
      graphite_host => 'graphite.example.com',
      graphite_port => 2013,
      interval      => 10,
    }

You can also add additional collectors:

    diamond::collector { 'RedisCollector':
      options => {
        'instances' => 'main@localhost:6379, other@localhost:6380'
      }
    }

Diamond supports a number of different handlers, for the moment this
module supports only the Graphite, Librato and Riemann handers. Pull request
happily accepted to add others.

With Librato:

    class { 'diamond':
      librato_user   => 'bob',
      librato_apikey => 'jim',
    }

With Riemann:

    class { 'diamond':
      riemann_host => 'riemann.example.com',
    }

Note that you can include more than one of these at once.

    class { 'diamond':
      librato_user   => 'bob',
      librato_apikey => 'jim',
      riemann_host   => 'riemann.example.com',
      graphite_host  => 'graphite.example.com',
    }

# Optional requirements

Diamond appears not to have a canonical package repository I could find
or a PPA or similar. PyPi has a record but not source or binary
packages. So this module can make use of my own personal debian package
repository. This is installed with the
[garethr](https://github.com/garethr/garethr-garethr) module if needed.
Alernatively host your own package repository.

The Riemann and Librato handlers require some additional Python
libraries not currently installed by this module.

    package {[
      'simplejson',
      'requests',
      'bernhard',
    ]:
      ensure   => installed,
      provider => pip,
    }

