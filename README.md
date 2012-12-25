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
      interval      => 10
    }

Diamond supports a number of different handlers, for the moment this
module supports only the Graphite and Librato handers. Pull request
happily accepted to add others.

    class { 'diamond':
      librato_user   => 'bob',
      librato_apikey => 'jim',
    }

# Requirement

Diamond appears not to have a canonical package repository I could find
or a PPA or similar. PyPi has a record but not source or binary
packages. So this module makes use of my own personal debian package
repository. This is installed with the
[garethr](https://github.com/garethr/garethr-garethr) module which is
marked as a dependency in the Modulefile.

