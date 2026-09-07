let
  mkEntry = fullAddress: overrides:
    {
      username = "Administrator";
      domain = "ad.tmspro.shop";
      inherit fullAddress;
    }
    // overrides;

  old = {
    username = "Administrator";
    domain = "ad.tmsproshop.de";
  };
in {
  "windows-admin-center" = mkEntry "10.0.50.10" {};
  "dc-01" = mkEntry "10.0.50.05" {};
  "dc-02" = mkEntry "10.0.50.06" {};
  # "exchange" = mkEntry "10.0.50.07" {};

  "timas" = mkEntry "10.102.99.80" {
    username = "LocalAdmin";
    domain = null;
  };
  "exchange-2019" = mkEntry "10.102.99.98" old;
  "dc-2016" = mkEntry "10.102.99.99" old;
}
