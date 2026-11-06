{ ... }:
{
  # Configuration for the `npm:@xzzpig/pi-sandbox` extension. Reads and writes
  # outside these lists are prompted for, which is what keeps the agent from
  # rewriting its own configuration or session history.
  home.file.".pi/agent/sandbox.json".text = ''
    {
      "enabled": true,
      "network": {
        // Network stays unfiltered like it was under opencode; the process
        // sandbox in the launcher does not restrict it either.
        "disabled": true,
        // This also skips the vendored apply-seccomp helper, which only blocks
        // AF_UNIX sockets inside sandboxed bash. npm drops its exec bit, and we
        // do not patch binaries at runtime, so the feature is off rather than
        // broken. File and history protection is unaffected: it comes from the
        // bwrap bind rules below plus the in-process read/write/edit guards.
        "allowAllUnixSockets": true
      },
      "filesystem": {
        "allowRead": [
          ".",
          "~/.config",
          "~/.local",
          "~/.nix-profile"
        ]
      }
    }
  '';
}
