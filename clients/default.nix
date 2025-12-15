let
  clients = [
    {
      hostName = "hp-430-g7";
      diskId = "nvme-eui.002538a301b0c2cd";
    }
    # {
    #   hostName = "tower-of-power";
    #   diskId = null;
    # }
  ];
in
  builtins.listToAttrs (map (c: {
      name = c.hostName;
      value = {inherit (c) hostName diskId;};
    })
    clients)
