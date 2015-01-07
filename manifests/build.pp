# (Internal) Installs elixir-build

class elixir::build(
  $ensure = $elixir::build::ensure,
  $prefix = $elixir::build::prefix,
  $user   = $elixir::build::user,
) {
  #  require elixir

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'mururu/elixir-build',
    user   => $user,
  }

  ensure_resource('file', "${::elixir::prefix}/cache/elixirs", {
    'ensure' => 'directory',
    'owner'  => $user,
  })

}
