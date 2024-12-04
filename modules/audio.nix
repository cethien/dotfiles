{ pkgs, ... }:

{
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber = {
      enable = true;

      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
        '')
      ];
    };


    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.noisetorch.enable = true;
}