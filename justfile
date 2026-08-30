username := `whoami`
hostname := `hostname -s`
system := `nix-instantiate --raw --strict --eval -E builtins.currentSystem`

# Show available commands
help:
  just -l

# Run flake formatter
fmt *args:
  fmtt {{args}}

# Run checks
ck *args:
    nix flake check {{args}}

# Build default shell
reload *args:
    nix build .#devShells.{{system}}.default {{args}}

# Activate a new home configuration only
home *args:
  {{username}}@{{hostname}} switch --ask --show-activation-logs {{args}}

# Build host configuration
build host=hostname *args:
  {{hostname}} build {{args}}

# Activate host configuration
switch host=hostname *args:
    {{hostname}} switch --ask --show-activation-logs {{args}}

# Clean up all old generations and store paths
clean *args:
    nh clean all --ask {{args}}

# Generate .github
dot-github:
    nix build .#dot-github
    cp -r --no-preserve=mode result/.github/* .github/

# Update inputs listed in `nix-config.primary-inputs`
update-primary:
    nix run .#update-primary
    flake-edit follow

# Update all inputs
update-all:
    nix flake update
    flake-edit follow
