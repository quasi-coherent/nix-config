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

# Regenerate .gitlab/workflows
ci:
    nix run .#render-workflows

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

# Update inputs listed in `nix-config.primary-inputs`
update:
    nix run .#update

# Regenerate flake.nix
flake:
    nix run .#write-flake
    nix run .#write-lock
