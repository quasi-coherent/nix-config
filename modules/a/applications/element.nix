{ a, ... }:
{
  our.nix-profile.includes = [ a.element ];

  a.element.homeManager.programs.element-desktop.enable = true;
}
