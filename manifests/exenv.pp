# Manage elixir versions with exenv.
#
# Usage:
#
#     include elixir::exenv
#
class elixir::exenv (
  $ensure = $elixir::exenv::ensure,
  $prefix = $elixir::exenv::prefix,
  $user   = $elixir::exenv::user,
) {

  # require elixir

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'mururu/exenv',
    user   => $user
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/elixirs',
    require => Repository[$prefix],
  }

}

