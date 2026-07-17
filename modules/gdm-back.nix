{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gdm-back;

  # Get the file extension from the background image, with robust handling
  backgroundExt =
    let path = toString cfg.backgroundImage;
    in
      if hasSuffix ".png" path then "png"
      else if hasSuffix ".jpg" path then "jpg"
      else if hasSuffix ".jpeg" path then "jpeg"
      else if hasSuffix ".webp" path then "webp"
      else "png"; # default to png if no recognized extension

  # Create the CSS for the background
  backgroundCSS = ''
    /* GDM Background CSS */
    .login-dialog { background: transparent; }
    #lockDialogGroup {
      background-image: url('resource:///org/gnome/shell/theme/background.${backgroundExt}');
      background-position: center;
      background-size: cover;
    }
  '';

in {
  options.services.gdm-back = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable custom GDM background image.
      '';
    };

    backgroundImage = mkOption {
      type = types.path;
      description = ''
        Path to the background image to use for GDM.
        Supported formats: png, jpg, jpeg, webp.
        The image will be embedded in the gnome-shell-theme.gresource file.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Ensure GDM is enabled
    services.xserver.displayManager.gdm.enable = mkDefault true;

    # Override gnome-shell with custom background via overlay
    nixpkgs.overlays = [
      (final: prev: {
        gnome = prev.gnome // {
          gnome-shell = prev.gnome.gnome-shell.overrideAttrs (oldAttrs: {
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ prev.glib.bin ];

            postFixup = (oldAttrs.postFixup or "") + ''
              set -e
              # Extract the gnome-shell-theme.gresource
              WORKDIR=$(mktemp -d)
              cd $WORKDIR

              # Extract all resources
              mkdir -p gnome-shell
              ${prev.glib.bin}/bin/gresource list $out/share/gnome-shell/gnome-shell-theme.gresource | while read resource; do
                filename=$(echo "$resource" | sed 's|^/org/gnome/shell/theme/||')
                filepath="gnome-shell/$filename"
                mkdir -p "$(dirname "$filepath")"
                ${prev.glib.bin}/bin/gresource extract $out/share/gnome-shell/gnome-shell-theme.gresource "$resource" > "$filepath"
              done

              # Copy the background image with proper extension
              cp ${cfg.backgroundImage} gnome-shell/background.${backgroundExt}

              # Append our CSS to gnome-shell.css
              if [ -f gnome-shell/gnome-shell.css ]; then
                echo "" >> gnome-shell/gnome-shell.css
                cat >> gnome-shell/gnome-shell.css <<CSS
${backgroundCSS}
CSS
              fi

              # Also append to dark/light variants if they exist (GNOME 50 uses dark.css)
              if [ -f gnome-shell/gnome-shell-dark.css ]; then
                echo "" >> gnome-shell/gnome-shell-dark.css
                cat >> gnome-shell/gnome-shell-dark.css <<CSS
${backgroundCSS}
CSS
              fi
              if [ -f gnome-shell/gnome-shell-light.css ]; then
                echo "" >> gnome-shell/gnome-shell-light.css
                cat >> gnome-shell/gnome-shell-light.css <<CSS
${backgroundCSS}
CSS
              fi

              # Create gresource XML
              cat > gnome-shell-theme.gresource.xml <<EOF
              <?xml version="1.0" encoding="UTF-8"?>
              <gresources>
                <gresource prefix="/org/gnome/shell/theme">
              $(find gnome-shell -type f -printf '    <file>%P</file>\n')
                </gresource>
              </gresources>
              EOF

              # Recompile the gresource
              ${prev.glib.bin}/bin/glib-compile-resources \
                --sourcedir gnome-shell \
                --target $out/share/gnome-shell/gnome-shell-theme.gresource \
                gnome-shell-theme.gresource.xml

              # Cleanup
              cd /
              rm -rf $WORKDIR
            '';
          });
        };
      })
    ];
  };
}
