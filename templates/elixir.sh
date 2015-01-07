# Put elixir-build on PATH
export PATH=<%= scope.lookupvar("::elixir::build::prefix") %>/bin:$PATH

# Configure EXENV_ROOT and put EXENV_ROOT/bin on PATH
export EXENV_ROOT=<%= scope.lookupvar("::elixir::exenv::prefix") %>
export PATH=$EXENV_ROOT/bin:$PATH

# Load exenv
eval "$(exenv init -)"

# Helper for shell prompts and the like
current_elixir() {
  echo "$(exenv version-name)"
}
