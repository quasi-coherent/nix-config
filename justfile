username := `whoami`
hostname := `hostname -s`
system := `nix-instantiate --raw --strict --eval -E builtins.currentSystem`

# Show available commands
help:
  just -l

# Run flake formatter
fmt *args:
  fmtt {{args}}

# Activate only home-manager configuration
home *args:
  {{username}}@{{hostname}} switch --ask {{args}}

# Build host configuration
build host=hostname *args:
  {{hostname}} build {{args}}

# Activate host configuration
switch host=hostname *args:
    {{hostname}} switch --ask {{args}}

# Clean up nix store
clean *args:
  nh clean all --ask {{args}}

# `nix flake update [args]`
update *args:
    nix flake update {{args}}
    auto-follow -i

# Regenerate flake.nix
flake:
    nix run .#write-flake

# Regenerate .gitlab/workflows
ci:
    nix run .#render-workflows
