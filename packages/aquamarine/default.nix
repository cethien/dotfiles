{
  lib,
  aquamarine,
}:
# aquamarine 0.16.0 ships without the DRM fixes from these upstream PRs, which
# cause atomic modeset failures on NVIDIA (hyprwm/aquamarine#472):
#   477 - do not create invalid all-zero HDR infoframe blobs for SDR displays
#   478 - synchronously recheck CRTCs when a connector is disabled
# Drop this package once nixpkgs provides aquamarine newer than 0.16.0.
aquamarine.overrideAttrs (old: lib.optionalAttrs (aquamarine.version == "0.16.0") {
  patches = (old.patches or []) ++ [
    ./478-sync-crtc-recheck.patch
    ./477-skip-invalid-hdr-blob.patch
  ];
})
