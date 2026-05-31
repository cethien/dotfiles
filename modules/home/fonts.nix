{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.userfonts;
in {
  options.userfonts.enable = lib.mkEnableOption "install userfonts and activate options";

  config = lib.mkIf cfg.enable {
    # fonts.fontconfig = {
    #   antialiasing = true;
    #   hinting = "slight";
    #   subpixelRendering = "rgb";
    #   configFile = {
    #     "99-lcdfilter" = {
    #       enable = true;
    #       text = ''
    #         <?xml version="1.0"?>
    #         <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    #         <fontconfig>
    #           <match target="font">
    #             <edit name="lcdfilter" mode="assign">
    #               <const>lcddefault</const>
    #             </edit>
    #           </match>
    #         </fontconfig>
    #       '';
    #     };
    #   };
    # };

    home.packages = with pkgs; [
      (google-fonts.override {
        fonts = [
          "Lato"
          "Oswald"
          "Nunito"
          "Akt"
          "Anton"

          "Henny Penny"
          "Fontdiner Swanky"
          "Oi"
          "Unkempt"
          "Luckiest Guy"
          "Knewave"
          "Jolly Lodger"
          "Gorditas"
          "Slackey"
          "Finger Paint"
          "Fascinate"
          "Story Script"
          "Libertinus Keyboard"
          "Rubik Doodle Shadow"
          "Indie Flower"
          "Cinzel Decorative"
          "Caveat"
          "Caveat Brush"
          "Comic relief"
          "Mansalva"
          "Special Elite"
          "Bad Script"
        ];
      })
      minecraftia
      comic-neue
      paratype-pt-sans
    ];
  };
}
