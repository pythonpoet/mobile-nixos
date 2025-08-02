{ stdenv
, pkgs
, lib
, fetchFromGitHub
, pkg-config
, freetype
, SDL2
, libdrm
, libevdev
, libinput
, libxkbcommon
, withSimulator ? false
}:

let
  inherit (lib) optional optionals;
  simulatorDeps = [
    SDL2
  ];
in
  stdenv.mkDerivation {
    pname = "lvgui";
    version = "2024-03-29";

    src = fetchFromGitHub {
      repo = "lvgui";
      owner = "mobile-nixos";
      rev = "8768bab377a7ccab0b25b96d204af670820f8c76";
      hash = "sha256-lDmUppndyDGY1EJT7FC6Fdb3AT2M6D75FnXw4bPNrD0=";
    };

    # Document `LVGL_ENV_SIMULATOR` in the built headers.
    # This allows the mrbgem to know about it.
    # (In reality this should be part of a ./configure step or something similar.)
    postPatch = ''
      sed -i"" '/^#define LV_CONF_H/a #define LVGL_ENV_SIMULATOR ${if withSimulator then "1" else "0"}' lv_conf.h
    '';

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      freetype
      libevdev
      libdrm
      libinput
      libxkbcommon
    ]
    ++ optionals withSimulator simulatorDeps
    ;

    makeFlags = [
      "PREFIX=${placeholder "out"}"
    ]
    ++ optional withSimulator "LVGL_ENV_SIMULATOR=1"
    ++ optional (!withSimulator) "LVGL_ENV_SIMULATOR=0"
    ;

    enableParallelBuilding = true;

    # https://github.com/mobile-nixos/lvgui/issues/23
    env.NIX_CFLAGS_COMPILE = "-Wno-error";
  }
