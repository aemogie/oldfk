{...}: {
  services.logind = {
    lidSwitch = "lock";
    powerKey = "lock";
    powerKeyLongPress = "poweroff";
  };
  # here cz idk where else
  security.pam.services.swaylock.text = "auth include login";
}
