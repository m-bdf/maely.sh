{
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells = {
          website = pkgs.mkShell {
            packages = with pkgs; [ nodejs_latest bun ];
            shellHook = "cd website";
          };

          resume = pkgs.mkShell {
            packages = with pkgs.elmPackages;
              [ elm elm-format elm-analyse elm-live ];
            shellHook = "cd resume";
          };
        };
      }
    );
}
