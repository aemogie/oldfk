{osConfig, ...}: {
  manifest_version = 2;

  browser_specific_settings.gecko.id = "custom@paint.nix";

  name = "paint.nix auto-generated theme";
  description = "Theme generated using home-manager paint.nix module.";
  author = "aemogie.";
  version = "0.1";

  # icons = {"32" = "icon.svg";};

  theme = {
    colors = let
      inherit (osConfig.paint.core) crust mantle base overlay0 text primary;
    in {
      frame = "#${crust}";
      icons = "#${primary}";
      popup = "#${base}";
      popup_highlight = "#${overlay0}";
      popup_text = "#${text}";
      sidebar = "#${base}";
      sidebar_border = "#${primary}";
      sidebar_text = "#${text}";
      tab_background_text = "#${text}";
      tab_icon_overlay_fill = "rgb(251,251,254)";
      tab_icon_overlay_stroke = "rgb(66,65,77)";
      tab_loading = "#${primary}";
      tab_selected = "#${base}";
      tab_text = "#${text}";
      toolbar = "#${base}";
      toolbar_bottom_separator = "#${base}";
      toolbar_field = "#${mantle}";
      toolbar_field_border = "#${base}";
      toolbar_field_focus = "#${base}";
      toolbar_field_highlight = "#${primary}";
      toolbar_field_highlight_text = "#${base}";
      toolbar_field_separator = "#${primary}";
      toolbar_field_text = "#${text}";
      toolbar_text = "#${text}";
      toolbar_vertical_separator = "#${primary}";
      toolbar_top_separator = "transparent";
    };
    properties = {
      panel_hover = "color-mix(in srgb; currentColor 9%; transparent)";
      panel_active = "color-mix(in srgb; currentColor 14%; transparent)";
      panel_active_darker = "color-mix(in srgb; currentColor 25%; transparent)";
      toolbar_field_icon_opacity = "1";
      zap_gradient = "linear-gradient(90deg; #9059FF 0%; #FF4AA2 52.08%; #FFBD4F 100%)";
    };
  };

  # theme_experiment = {
  #   colors = {
  #     button = "--button-bgcolor";
  #     button_hover = "--button-hover-bgcolor";
  #     button_active = "--button-active-bgcolor";
  #     button_primary = "--button-primary-bgcolor";
  #     button_primary_hover = "--button-primary-hover-bgcolor";
  #     button_primary_active = "--button-primary-active-bgcolor";
  #     button_primary_color = "--button-primary-color";
  #     input_background = "--input-bgcolor";
  #     input_color = "--input-color";
  #     input_border = "--input-border-color";
  #     autocomplete_popup_separator = "--autocomplete-popup-separator-color";
  #     appmenu_update_icon_color = "--panel-banner-item-update-supported-bgcolor";
  #     appmenu_info_icon_color = "--panel-banner-item-info-icon-bgcolor";
  #     tab_icon_overlay_stroke = "--tab-icon-overlay-stroke";
  #     tab_icon_overlay_fill = "--tab-icon-overlay-fill";
  #   };
  #   properties = {
  #     panel_hover = "--panel-item-hover-bgcolor";
  #     panel_active = "--arrowpanel-dimmed-further";
  #     panel_active_darker = "--panel-item-active-bgcolor";
  #     toolbar_field_icon_opacity = "--urlbar-icon-fill-opacity";
  #     zap_gradient = "--panel-separator-zap-gradient";
  #   };
  # };
}
