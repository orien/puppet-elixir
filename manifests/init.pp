# Class: elixir
#
# This module installs a full exenv-driven elixir stack
#
class elixir(
  $prefix   = $elixir::prefix,
  $user     = $elixir::user,
) {

  include boxen::config
  include elixir::build
  include elixir::exenv

  boxen::env_script { 'elixir':
    content  => template('elixir/elixir.sh'),
    priority => 'higher',
  }

  file { '/opt/elixirs':
    ensure => directory,
    owner  => $user,
  }

  Class['elixir::build'] ->
    Elixir::Definition <| |> ->
    Class[elixir::exenv] ->
    Elixir <| |> #->
    #  Elixir_gem <| |>
}
