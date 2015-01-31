# Elixir Puppet Module for Boxen

[![Build Status](https://travis-ci.org/orien/puppet-elixir.svg?branch=master)](https://travis-ci.org/orien/puppet-elixir)

Requires the following boxen modules:

* `boxen`
* `repository`
* `homebrew`
* `erlang`

## About

This module supports Elixir version management with exenv. All Elixir versions
are installed into `/opt/elixirs`.

## About elixir-build version

Occasional bumps to the default elixir-build version are fine, on this module,
but not essential. The elixir-build version is something you should be managing
in your own boxen repository, rather than depending on this module to update
for you. See examples on how to change the elixir-build version in the Hiera
section.

You can find a release list of versions for elixir-build
[here](https://github.com/mururu/elixir-build/releases).

## Usage

```puppet
# Set the global default Elixir (auto-installs it if it can)
class { 'elixir::global':
  version => '1.0.0'
}

# ensure a certain elixir version is used in a dir
elixir::local { '/path/to/some/project':
  version => '1.0.2'
}

# install a elixir version
elixir::version { '1.0.1': }
```

## Hiera configuration

The following variables may be automatically overridden with Hiera:

``` yaml
---

"elixir::user": "deploy"
"elixir::build::ensure": "v20141001"
"elixir::exenv::ensure": "v0.1.0"
```

You can also use JSON if your Hiera is configured for that.
