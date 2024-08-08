{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.aider;
in {
  options.programs.aider = {
    enable = mkEnableOption "aider";
    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./aider-package.nix {};
      defaultText = literalExpression "pkgs.callPackage ./aider-package.nix {}";
      description = "The aider package to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
