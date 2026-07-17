{ backgroundImage }:

final: prev:

let
  lib = prev.lib;

  backgroundExt =
    let
      path = toString backgroundImage;
    in
      if lib.hasSuffix ".png" path then "png"
      else if lib.hasSuffix ".jpg" path then "jpg"
      else if lib.hasSuffix ".jpeg" path then "jpeg"
      else if lib.hasSuffix ".webp" path then "webp"
      else "png";

  backgroundCSS = ''
    /* Custom GDM background */
    #lockDialogGroup {
      background-image: url("resource:///org/gnome/shell/theme/background.${backgroundExt}");
      background-position: center;
      background-size: cover;
    }
  '';

in {
  gnome = prev.gnome // {
    gnome-shell = prev.gnome.gnome-shell.overrideAttrs (oldAttrs: {
      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [ prev.glib.dev ];

      postFixup = (oldAttrs.postFixup or "") + ''
        set -e

        WORKDIR=$(mktemp -d)
        cd $WORKDIR

        mkdir -p gnome-shell

        # Extract existing resources
        ${prev.glib.dev}/bin/gresource list \
          $out/share/gnome-shell/gnome-shell-theme.gresource | while read resource; do

          filename=$(echo "$resource" | sed 's|^/org/gnome/shell/theme/||')
          filepath="gnome-shell/$filename"

          mkdir -p "$(dirname "$filepath")"

          ${prev.glib.dev}/bin/gresource extract \
            $out/share/gnome-shell/gnome-shell-theme.gresource \
            "$resource" > "$filepath"

        done

        # Add image
        cp ${backgroundImage} \
          gnome-shell/background.${backgroundExt}


        # Patch GNOME CSS files
        for css in gnome-shell/*.css; do
          if [ -f "$css" ]; then
            cat >> "$css" <<'CSS'

${backgroundCSS}

CSS
          fi
        done


        # Generate XML
        cat > gnome-shell-theme.gresource.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
$(find gnome-shell -type f -printf '    <file>%P</file>\n')
  </gresource>
</gresources>
EOF


        # Rebuild resource
        ${prev.glib.dev}/bin/glib-compile-resources \
          --sourcedir gnome-shell \
          --target $out/share/gnome-shell/gnome-shell-theme.gresource \
          gnome-shell-theme.gresource.xml


        rm -rf $WORKDIR
      '';
    });
  };
}