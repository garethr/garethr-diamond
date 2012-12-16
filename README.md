A Puppet module for managing the installation and configuration of
[Diamond](https://github.com/BrightcoveOS/Diamond).

[![Build
Status](https://secure.travis-ci.org/garethr/garethr-diamond.png)](http://travis-ci.org/garethr/garethr-diamond)

# Usage

For experimenting you're probably fine just with:

    include diamond

## Configuration

This module currently exposes a few configurable options, for the
Graphite host and polling interval. So you can also do:

    class ('diamond':
      host     => 'graphite.example.com',
      interval => 10
    }

# Requirement

Diamond appears not to have a canonical package repository I could find
or a PPA or similar. PyPi has a record but not source or binary
packages. So this module makes use of my own personal debian package
repository. This is installed with the
[garethr](https://github.com/garethr/garethr-garethr) module which is
marked as a dependency in the Modulefile.

