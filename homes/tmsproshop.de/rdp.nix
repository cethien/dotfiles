let
  shared = {
    username = "Administrator";
    domain = "ad.tmsproshop.de";
    authenticationLevel = 2;
    dynamicResolution = true;
  };
in {
  "ad_dc_dns" = shared // {fullAddress = "10.102.99.98";};
  "exchange" = shared // {fullAddress = "10.102.99.99";};
  "timas" =
    shared
    // {
      fullAddress = "10.102.99.80";
      domain = "";
      username = "LocalAdmin";
    };
  "hyper-v" = shared // {fullAddress = "10.102.99.89";};
}
