# Public: specify the global elixir version
#
# Usage:
#
#   class { 'elixir::global': version => '1.0.0' }

class elixir::global($version = '1.0.0') {
  # require elixir

  ensure_resource('elixir::version', $version)

  file { "${elixir::exenv::prefix}/version":
    ensure  => present,
    owner   => $elixir::user,
    mode    => '0644',
    content => "${version}\n",
    require => Elixir::Version[$version],
  }
}
