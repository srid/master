{
  description = "Unwoke'ify script runner";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.writeShellApplication {
          name = "unwokeify";
          runtimeInputs = [ pkgs.gh ];
          text = builtins.readFile ./script.sh;
        };

        apps.default = {
          type = "app";
          program = "${config.packages.default}/bin/unwokeify";
        };
      };
    };
}
