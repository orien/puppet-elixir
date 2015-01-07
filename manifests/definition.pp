# Public: elixir::definition allows you to install a elixir-build definition.
#
#   source =>
#     The puppet:// source to install from. If undef, looks in
#     puppet:///modules/elixir/definitions/${name}.

define elixir::definition(
  $source = undef,
) {
  include elixir
  include elixir::build

  $source_path = $source ? {
    undef   => "puppet:///modules/elixir/definitions/${name}",
    default => $source
  }

  file { "${elixir::build::prefix}/share/elixir-build/${name}":
    source  => $source_path
  }
}
