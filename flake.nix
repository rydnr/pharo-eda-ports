{
  description = "Flake for rydnr/pharo-eda-ports";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    pharo-vm-12 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/pharo-vm-12.0.1519.4?dir=pharo-vm";
    };
    pharo-eda-api-12 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pharo-eda-common-12.follows = "pharo-eda-common-12";
      inputs.pharo-vm-12.follows = "pharo-vm-12";
      url = "github:rydnr/pharo-eda-api/0.1.0";
    };
    pharo-eda-common-12 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pharo-vm-12.follows = "pharo-vm-12";
      url = "github:rydnr/pharo-eda-common/0.1.1";
    };
    pharo-eda-errors-12 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pharo-eda-common-12.follows = "pharo-eda-common-12";
      inputs.pharo-vm-12.follows = "pharo-vm-12";
      url = "github:rydnr/pharo-eda-errors/0.1.0";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "rydnr";
        repo = "pharo-eda-ports";
        pname = "${repo}";
        tag = "0.1.0";
        baseline = "PharoEDAPorts";
        pkgs = import nixpkgs { inherit system; };
        description = "Discovers adapters and injects them into ports";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/rydnr/pharo-eda-ports";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ./nix/shared.nix;
        pharo-eda-ports-for = { bootstrap-image-name, bootstrap-image-sha256, bootstrap-image-url, pharo-vm, pharo-eda-api, pharo-eda-common, pharo-eda-errors }:
          let
            bootstrap-image = pkgs.fetchurl {
              url = bootstrap-image-url;
              sha256 = bootstrap-image-sha256;
            };
            src = ./src;
          in pkgs.stdenv.mkDerivation (finalAttrs: {
            version = tag;
            inherit pname src;

            strictDeps = true;

            buildInputs = with pkgs; [
            ];

            nativeBuildInputs = with pkgs; [
              pharo-vm
              pkgs.unzip
            ];

            unpackPhase = ''
              unzip -o ${bootstrap-image} -d image
              cp -r ${src} src
              mkdir -p $out/share/src/${pname}
            '';

            configurePhase = ''
              runHook preConfigure

              substituteInPlace src/BaselineOfPharoEDAPorts/BaselineOfPharoEDAPorts.class.st \
                --replace-fail "github://rydnr/pharo-eda-api:main" "tonel://${pharo-eda-api}/share/src/pharo-eda-api" \
                --replace-fail "github://rydnr/pharo-eda-common:main" "tonel://${pharo-eda-common}/share/src/pharo-eda-common" \
                --replace-fail "github://rydnr/pharo-eda-errors:main" "tonel://${pharo-eda-errors}/share/src/pharo-eda-errors"

              # load baseline
              ${pharo-vm}/bin/pharo image/${bootstrap-image-name} eval --save "EpMonitor current disable. NonInteractiveTranscript stdout install. [ Metacello new repository: 'tonel://$PWD/src'; baseline: '${baseline}'; onConflictUseLoaded; load ] ensure: [ EpMonitor current enable ]"

              runHook postConfigure
            '';

            buildPhase = ''
              runHook preBuild

              # assemble
              ${pharo-vm}/bin/pharo image/${bootstrap-image-name} save "${pname}"

              mkdir dist
              mv image/${pname}.* dist/

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp -r ${pharo-vm}/bin $out
              cp -r ${pharo-vm}/lib $out
              cp -r dist/* $out/
              cp image/*.sources $out/
              pushd src
              cp -r . $out/share/src/${pname}
              ${pkgs.zip}/bin/zip -r $out/share/${pname}.zip .
              popd

              runHook postInstall
             '';

            meta = {
              changelog = "https://github.com/rydnr/pharo-eda-ports/releases/";
              longDescription = ''
      This project inspects the published PharoEDA-Adapters and makes them available to create new `EDAApplication` instances.
              '';
              inherit description homepage license maintainers;
              mainProgram = "pharo";
              platforms = pkgs.lib.platforms.linux;
            };
        });
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pharo-eda-ports-12;
          pharo-eda-ports-12 = shared.devShell-for {
            package = packages.pharo-eda-ports-12;
            inherit org pkgs repo tag;
            nixpkgs-release = nixpkgsRelease;
          };
        };
        packages = rec {
          default = pharo-eda-ports-12;
          pharo-eda-ports-12 = pharo-eda-ports-for rec {
            bootstrap-image-url = pharo-vm-12.resources.${system}.bootstrap-image-url;
            bootstrap-image-sha256 = pharo-vm-12.resources.${system}.bootstrap-image-sha256;
            bootstrap-image-name = pharo-vm-12.resources.${system}.bootstrap-image-name;
            pharo-vm = pharo-vm-12.packages.${system}.pharo-vm;
            pharo-eda-api = pharo-eda-api-12.packages.${system}.pharo-eda-api-12;
            pharo-eda-common = pharo-eda-common-12.packages.${system}.pharo-eda-common-12;
            pharo-eda-errors = pharo-eda-errors-12.packages.${system}.pharo-eda-errors-12;
          };
        };
      });
}
