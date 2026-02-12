let
  shared = {
    username = "Administrator";
    domain = "tmspro.shop";
    authenticationLevel = 2;
    dynamicResolution = true;
  };
  old.domain = "ad.tmsproshop.de";
in {
  "dc-02" = shared // {fullAddress = "10.0.50.12";};
  "dc-01" = shared // {fullAddress = "10.0.50.11";};
  "exchange" = shared // {fullAddress = "10.0.50.10";};
  "timas" =
    shared
    // {
      fullAddress = "10.102.99.80";
      username = "LocalAdmin";
      domain = null;
    };

  "hyper-v" = shared // old // {fullAddress = "10.102.99.89";};
  "exchange-2019" = shared // old // {fullAddress = "10.102.99.98";};
  "dc-2016" = shared // old // {fullAddress = "10.102.99.99";};
}
