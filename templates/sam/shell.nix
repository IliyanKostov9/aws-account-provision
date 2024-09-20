{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    jdk11
    zsh
  ];

  runScript = "zsh";
  JAVA_HOME = "${pkgs.jdk11}/lib/openjdk";
}
