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
    "skel/.config/umbriel/config.toml".text = builtins.readFile ./skel/umbriel/config.toml;
    "skel/.config/umbriel/src/appearance.toml".text = builtins.readFile ./skel/umbriel/src/appearance.toml;
    "skel/.config/umbriel/src/animation.toml".text = builtins.readFile ./skel/umbriel/src/animation.toml;
    "skel/.config/umbriel/src/general.toml".text = builtins.readFile ./skel/umbriel/src/general.toml;
    "skel/.config/umbriel/src/input.toml".text = builtins.readFile ./skel/umbriel/src/input.toml;
    "skel/.config/umbriel/src/keybinds.toml".text = builtins.readFile ./skel/umbriel/src/keybinds.toml;
    "skel/.config/umbriel/src/layout.toml".text = builtins.readFile ./skel/umbriel/src/layout.toml;
    "skel/.config/umbriel/src/outputs.toml".text = builtins.readFile ./skel/umbriel/src/outputs.toml;
    "skel/.config/umbriel/src/rules.toml".text = builtins.readFile ./skel/umbriel/src/rules.toml;
    "xdg/umbriel/config.toml".text = builtins.readFile ./skel/umbriel/config.toml;
    "xdg/umbriel/src/appearance.toml".text = builtins.readFile ./skel/umbriel/src/appearance.toml;
    "xdg/umbriel/src/animation.toml".text = builtins.readFile ./skel/umbriel/src/animation.toml;
    "xdg/umbriel/src/general.toml".text = builtins.readFile ./skel/umbriel/src/general.toml;
    "xdg/umbriel/src/input.toml".text = builtins.readFile ./skel/umbriel/src/input.toml;
    "xdg/umbriel/src/keybinds.toml".text = builtins.readFile ./skel/umbriel/src/keybinds.toml;
    "xdg/umbriel/src/layout.toml".text = builtins.readFile ./skel/umbriel/src/layout.toml;
    "xdg/umbriel/src/outputs.toml".text = builtins.readFile ./skel/umbriel/src/outputs.toml;
    "xdg/umbriel/src/rules.toml".text = builtins.readFile ./skel/umbriel/src/rules.toml;
    "skel/.config/noctalia/noctalia-config.toml".text = builtins.readFile ./skel/noctalia/noctalia-config.toml;
    "skel/.config/gtk-3.0/bookmarks".text = builtins.readFile ./skel/gtk-3.0/bookmarks;
    "skel/.config/gtk-3.0/gtk.css".text = builtins.readFile ./skel/gtk-3.0/gtk.css;
    "skel/.config/gtk-3.0/noctalia.css".text = builtins.readFile ./skel/gtk-3.0/noctalia.css;
    "skel/.config/gtk-3.0/settings.ini".text = builtins.readFile ./skel/gtk-3.0/settings.ini;
  };
}