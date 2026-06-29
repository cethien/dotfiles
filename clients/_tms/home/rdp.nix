let
  shared = {
    username = "Administrator";
    domain = "tmspro.shop";
  };
  old.domain = "ad.tmsproshop.de";
in {
  # "exchange" = shared // {fullAddress = "10.0.50.10";};
  # "dc-01" = shared // {fullAddress = "10.0.50.11";};
  # "dc-02" = shared // {fullAddress = "10.0.50.12";};

  "timas" = {
    fullAddress = "10.102.99.80";
    username = "LocalAdmin";
  };
  "exchange-2019" = shared // old // {fullAddress = "10.102.99.98";};
  "dc-2016" = shared // old // {fullAddress = "10.102.99.99";};
}
