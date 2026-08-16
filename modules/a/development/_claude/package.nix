{
  lib,
  claudeCode,
  configDir,
  name,
  writeShellApplication,
}:
writeShellApplication {
  inherit name;
  runtimeInputs = [claudeCode];

  text = ''
    export CLAUDE_CONFIG_DIR=${lib.escapeShellArg configDir}
    exec ${lib.getExe claudeCode} "$@"
  '';
}
