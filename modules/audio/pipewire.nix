{ lib, config, pkgs, ... }:

{
  options.audio.pipewire.enable = lib.mkEnableOption "Enable pipewire";

  config = lib.mkIf config.audio.pipewire.enable {
    
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.pipewire.wireplumber = { 
      enable = true; 

      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
        '')
      ];    
    };

  };  
}