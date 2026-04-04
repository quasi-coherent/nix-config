username := `whoami`
hostname := `hostname -s`
system := `nix-instantiate --raw --strict --eval -E builtins.currentSystem`

# Show available commands
help:
  just -l

# Regenerate flake.nix and lockfile
inputs:
    nix run .#write-flake
    nix flake update
    auto-follow -i

# Format and lint
fmt *args:
  fmtt {{args}}

# Clean up nix store
clean *args:
  nh clean all --ask {{args}}

# Activate only home-manager configuration
home *args:
  {{username}}@{{hostname}} switch --ask {{args}}

# Build host configuration
build host=hostname *args:
  {{hostname}} build {{args}}

# Activate host configuration
switch host=hostname *args:
  {{hostname}} switch --ask {{args}}
