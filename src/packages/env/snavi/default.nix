{
  config,
  ...
}:
{
  programs.snavi.enable = true;

  my.packages.snavi = config.programs.snavi.package;

  programs.bash.initExtra = ''
    s() {
      local result="$(${config.programs.snavi.wrapperName})"
      echo "$result"
      history -s -- "$result"
      echo "Saved to history."
    }
  '';
}
