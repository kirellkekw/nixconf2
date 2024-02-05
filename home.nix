{
  config,
  pkgs,
  ...
}: {
  home.username = "kirell";
  home.stateVersion = "22.11";
  nixpkgs.config.allowUnfree = true;
  programs.vscode.package = pkgs.vscode-fhsWithPackages (ps: with ps; [gcc gdb gnumake cmake python-with-packages]);
}