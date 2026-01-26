{pkgs, ...}:
pkgs.mkShell {
  packages = let
    runPkg = pkgs.writeShellApplication {
      name = "dot";
      runtimeInputs = with pkgs; [bash argc yq-go openssh];
      checkPhase = ''
        export LC_ALL=en_US.UTF-8
        runHook preCheck
        # shellcheck "$target"
        runHook postCheck
      '';
      text = builtins.readFile ./dot.sh;
    };
  in
    with pkgs; [
      nixpkgs-fmt
      sops

      python3
      yq-go
      argc
      runPkg
    ];
}
