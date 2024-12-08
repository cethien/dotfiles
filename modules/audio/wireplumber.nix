{ pkgs, ... }:

{
  services.pipewire.wireplumber.enable = true;
  
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
      wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
    '')
  ];    
}