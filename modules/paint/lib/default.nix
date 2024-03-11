{lib, ...}: let
  inherit (builtins) length isList isAttrs isString hasAttr elemAt all replaceStrings attrNames attrValues stringLength elem;
  inherit (lib) mkOption mod;
  inherit (lib.strings) charToInt concatMapStrings stringToCharacters toLower;
  types = let
    inherit (lib.types) mkOptionType ints;
  in {
    rgbColor = mkOptionType {
      name = "RGB Colour";
      check = v:
        if isList v
        then (length v) == 3 && all ints.u8.check
        else if isAttrs v
        then let
          c = a: hasAttr a v && ints.u8.check v.${a};
        in
          (c "r") && (c "g") && (c "b")
        else if isString v
        then stringLength v == 6 && all (c: elem c conversion.hexChars) (stringToCharacters v)
        else false;
    };
  };
  options = {
    mkColorOption = default: let
      apply = v:
        {__toString = conversion.rgbToHex;}
        // (
          if isList v
          then {
            r = elemAt v 0;
            g = elemAt v 1;
            b = elemAt v 2;
          }
          else if isAttrs v
          then v
          else if isString v
          then conversion.hexToRgb v
          else throw "Value cannot be coerced into an RGB color."
        );
    in
      mkOption {
        inherit apply;
        default = apply default;
        type = types.rgbColor;
        example = {
          r = 255;
          g = 255;
          b = 255;
        };
        description = "An RGB color represented as a list of 3 integers between 0 and 255.";
      };
  };
  conversion = rec {
    hexChars = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f"];
    decToHex = v: (elemAt hexChars (mod (v / 16) 16)) + (elemAt hexChars (mod v 16));
    hexToDec = let
      numS = charToInt "0";
      numE = charToInt "9";
      alnS = charToInt "a";
      alnE = charToInt "f";
    in
      x: let
        c = charToInt x;
      in
        if numS <= c && c <= numE
        then c - numS
        else if alnS <= c && c <= alnE
        then c - alnS + 10
        else abort "Invalid hexadecimal integer!";
    rgbToHex = v: let
      rgb = [v.r v.g v.b];
    in
      if all (x: 0 <= x && x <= 255) rgb
      then concatMapStrings decToHex rgb
      else abort "Color was invalid!";
    hexToRgb = hex: let
      arr = map hexToDec (stringToCharacters (toLower hex));
      ch = x: y: ((elemAt arr x) * 16) + (elemAt arr y);
    in {
      r = ch 0 1;
      g = ch 2 3;
      b = ch 4 5;
    };
  };
  misc = {
    replaceVars = vars: replaceStrings (map (k: "@${k}@") (attrNames vars)) (map toString (attrValues vars));
  };
in {config.lib.paint = {inherit options types conversion misc;};}
