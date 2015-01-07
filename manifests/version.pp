# Installs a elixir version with elixir-build..
# Takes ensure, env, and version params.
#
# Usage:
#
#     elixir::version { '1.0.0': }

define elixir::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name
) {

  require elixir
  require elixir::build

  $default_env = {
    'CC' => '/usr/bin/cc',
  }

  if $::operatingsystem == 'Darwin' {
    include homebrew::config
    include boxen::config
    ensure_resource('package', 'readline')
    Package['readline'] -> Elixir <| |>
  }

  $hierdata = hiera_hash('elixir::version::env', {})

  if has_key($hierdata, $::operatingsystem) {
    $os_env = $hierdata[$::operatingsystem]
  } else {
    $os_env = {}
  }

  if has_key($hierdata, $version) {
    $version_env = $hierdata[$version]
  } else {
    $version_env = {}
  }

  $_env = merge(merge(merge($default_env, $os_env), $version_env), $env)

  if has_key($_env, 'CC') and $_env['CC'] =~ /gcc/ {
    require gcc
  }

  elixir { $version:
    ensure        => $ensure,
    environment   => $_env,
    elixir_build  => "${elixir::build::prefix}/bin/elixir-build",
    user          => $elixir::user,
    provider      => elixirbuild,
  }

}
