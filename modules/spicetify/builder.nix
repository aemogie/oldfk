{
  config,
  theme,
  extensions,
  custom_apps,
  ...
}: {
  lib,
  spotify,
  spicetify-cli,
  coreutils-full,
  makeWrapper,
  ...
}: let
  inherit (builtins) isAttrs isList concatStringsSep;
  inherit (lib.strings) optionalString;

  toINI = lib.generators.toINI {
    # specifies how to format a key/value pair
    mkKeyValue =
      lib.generators.mkKeyValueDefault
      {
        # specifies the generated string for a subset of nix values
        mkValueString = v:
          if v == true
          then "1"
          else if v == false
          then "0"
          else if isList v
          then builtins.concatStringsSep "|" v
          # else if isString v then ''"${v}"''
          # and delegates all other values to the default generator
          else lib.generators.mkValueStringDefault {} v;
      } "=";
  };
  lnListIntoDir = dir: list: concatStringsSep "\n" (map (path: "ln -s ${path} ${dir}/${baseNameOf path}") list);
in
  spotify.overrideAttrs (old: {
    pname = "spicetify";
    buildInputs = (old.buildInputs or []) ++ [spicetify-cli coreutils-full makeWrapper];
    postInstall =
      (old.postInstall or "")
      + ''
        set -e
        export SPICETIFY_CONFIG=$out/share/spicetify
        mkdir -p $SPICETIFY_CONFIG

        # grab the css map
        ln -s ${spicetify-cli.src}/css-map.json $SPICETIFY_CONFIG/css-map.json

        pushd $SPICETIFY_CONFIG

        # create config and prefs
        cat <<EOF > config-xpui.ini
        ${toINI config}
        EOF

        chmod a+wr config-xpui.ini
        touch $out/share/spotify/prefs

        substituteInPlace config-xpui.ini \
          --subst-var-by SPOTIFY_PATH $out/share/spotify \
          --subst-var-by PREFS_PATH $out/share/spotify/prefs

        ${optionalString (theme.enable) ''
          mkdir -p Themes
          ${
            if isAttrs theme.colorScheme
            # cp instead of ln so i can set colorscheme
            then "cp -rn"
            else "ln -s"
          } ${theme.path} Themes/${baseNameOf theme.path}
          chmod -R a+wr Themes
        ''}

        mkdir -p Extensions
        ${lnListIntoDir "Extensions" extensions}
        chmod -R a+wr Extensions

        mkdir -p CustomApps
        ${lnListIntoDir "CustomApps" custom_apps}
        chmod -R a+wr CustomApps

        ${optionalString (theme.enable && (isAttrs theme.colorScheme)) ''
          echo -en '\n' >> Themes/${theme.name}/color.ini
          cat <<EOF >> Themes/${theme.name}/color.ini
          [${theme.customColorSchemeName}]
          ${toINI theme.colorScheme}
          EOF
        ''}

        popd > /dev/null
        spicetify-cli --no-restart backup apply
      '';
  })
