# Set a directory's default elixir version via exenv.
# Automatically ensures that elixir version is installed via exenv.
#
# Usage:
#
#     elixir::local { '/path/to/a/thing': version => '1.0.0' }

define elixir::local($version = undef, $ensure = present) {
  include elixir

  case $version {
    undef:    { $_elixir_local_require = undef }
    default:  {
      ensure_resource('elixir::version', $version)
      $_elixir_local_require = Elixir::Version[$version]
    }
  }

  file { "${name}/.exenv-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true,
    require => $_elixir_local_require,
  }
}
