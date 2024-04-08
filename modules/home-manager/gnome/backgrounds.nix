{ pkgs, config, lib, ... }:
let
  backgrounds-git = pkgs.fetchFromGitHub {
    name = "miniluz-backgrounds";
    owner = "miniluz";
    repo = "backgrounds";
    rev = "b9061904aa40b3c091340f3dfa062e44376d532c";
    hash = "sha256-0Xe8g9DLdrH2jMcPcwZKEV/NFdRBzqUnUPdSLlc8W+A=";
  };
  cfg = config.miniluz.gnome.background;
in
{
  options.miniluz.gnome.background = {
    enable = lib.mkEnableOption "Enable a background";
    path = lib.mkOption {
      type = lib.types.str;
      example = "persona_3_blue_down.png";
      description = "Path of the theme relative to the Git repo";
    };
  };

  config = lib.mkIf cfg.enable {
    dconf.settings."org/gnome/desktop/background".picture-uri = lib.mkForce "file://${backgrounds-git}/${cfg.path}";
    dconf.settings."org/gnome/desktop/background".picture-uri-dark = lib.mkForce "file://${backgrounds-git}/${cfg.path}";
    dconf.settings."org/gnome/desktop/screensaver".picture-uri = lib.mkForce "file://${backgrounds-git}/${cfg.path}";
  };
}
