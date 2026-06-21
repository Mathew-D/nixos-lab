{ config, pkgs, ... }:

{
  environment.etc = {
    "skel/.config/foot/foot.ini".text = builtins.readFile ./skel/foot/foot.ini;
    "skel/.config/foot/dank-colors.ini".text = builtins.readFile ./skel/foot/dank-colors.ini;
    "skel/.config/foot/themes/noctalia".text = builtins.readFile ./skel/foot/themes/noctalia;
    "skel/.config/niri/config.kdl".text = builtins.readFile ./skel/niri/config.kdl;
    "skel/.config/niri/noctalia.kdl".text = builtins.readFile ./skel/niri/noctalia.kdl;
    "skel/.config/niri/src/animations.kdl".text = builtins.readFile ./skel/niri/src/animations.kdl;
    "skel/.config/niri/src/binds.kdl".text = builtins.readFile ./skel/niri/src/binds.kdl;
    "skel/.config/niri/src/input.kdl".text = builtins.readFile ./skel/niri/src/input.kdl;
    "skel/.config/niri/src/layout.kdl".text = builtins.readFile ./skel/niri/src/layout.kdl;
    "skel/.config/niri/src/misc.kdl".text = builtins.readFile ./skel/niri/src/misc.kdl;
    "skel/.config/niri/src/rules.kdl".text = builtins.readFile ./skel/niri/src/rules.kdl;
    "skel/.config/niri/src/spawn.kdl".text = builtins.readFile ./skel/niri/src/spawn.kdl;
    "skel/.config/noctalia/noctalia-config.toml".text = builtins.readFile ./skel/noctalia/noctalia-config.toml;
  };
}