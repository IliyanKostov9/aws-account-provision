{
  description = "Terraform project";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.systems.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-terraform.url = "github:stackbuilders/nixpkgs-terraform";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    devenv,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # NOTE: Unfree packages
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        devenv.shells.default = {
          languages.terraform = {
            enable = true;
            lsp.enable = true;
            version = "1.9.8";
          };

          packages = with pkgs; [
            #hello
          ];

          # NOTE: First do devenv shell
          # git-hooks.hooks = {
          #   actionlint =
          #     {
          #       enable = true;
          #       excludes = [ "docker-publish.yaml" ];
          #     };
          #   checkmake.enable = true;
          # };
        };
      };
    };
}
