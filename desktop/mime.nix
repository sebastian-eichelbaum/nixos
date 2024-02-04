{ config, lib, pkgs, ... }:

{
  #############################################################################
  # XDG Mime and Default Apps
  #

  # This allows to configure the XDG Mime <-> App mapping.
  # I.e. - you want SVG to always open in Inkscape, define it here.
  xdg.mime = {
    enable = true;

    # Default mappings.
    # WARNING: some application desktop files are wierdly named. Check the contents
    # of the appropriate package for details
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";

      # Images:
      "image/" =
        [ "org.gnome.gThumb.desktop" "org.gnome.Loupe.desktop" "gimp.desktop" ];
      "image/svg+xml" = [
        "org.gnome.gThumb.desktop"
        "org.gnome.Loupe.desktop"
        "org.inkscape.Inkscape.desktop"
        "gimp.desktop"
      ];
      "image/png" =
        [ "org.gnome.gThumb.desktop" "org.gnome.Loupe.desktop" "gimp.desktop" ];
      "image/jpg" =
        [ "org.gnome.gThumb.desktop" "org.gnome.Loupe.desktop" "gimp.desktop" ];
      "image/jpeg" = [
        "org.gnome.gThumb.desktop"
        "org.gnome.Loupe.desktop"
        "gimp.desktop"
      ]; # different from jpg. Why?
      "image/gif" =
        [ "org.gnome.gThumb.desktop" "org.gnome.Loupe.desktop" "gimp.desktop" ];

      "image/webp" =
        [ "org.gnome.gThumb.desktop" "org.gnome.Loupe.desktop" "gimp.desktop" ];

      # Text
      "text/" = [ "nvim.desktop" "code.desktop" ];
      "text/plain" = [ "nvim.desktop" "code.desktop" ];
    };

    # Add other software explicitly.
    addedAssociations = { };

    # Remove these mappings explicitly:
    # removedAssociations
  };

}
