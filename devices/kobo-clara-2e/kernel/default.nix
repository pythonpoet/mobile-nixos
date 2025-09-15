{
  linuxManualConfig
, fetchFromGitHub
, lzop
, stdenv
, lib
, ...
}:

(linuxManualConfig {
  inherit stdenv lib;
  version = "5.19.11";
  src = fetchFromGitHub {
    owner = "akemnade";
    repo = "linux";
    rev = "14094f669808ea48f3cea07f35b64cb6ece6f27e";
    sha256 = "sha256-DC7iASDS6emkj2qkHQ7bkWDCKJpKcLs9EM/kTeejwSg=";
  };
  configfile = ./config.armv7l;
  config = import ./config.armv7l.nix;
}).overrideAttrs (attrs: {
  nativeBuildInputs = attrs.nativeBuildInputs ++ [ lzop ];
  patches = attrs.patches ++ [
    ./0001-sy7636-set-pdata-before-adding-mfd-devices.patch
    ./0002-WIP-Kobo-Clara-2e.patch
  ];
})
