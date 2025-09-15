{ config, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkOption mkIf types;
  cfg = config.mobile.hardware.socs;
  anyExynos = lib.any (v: v) [
    cfg.exynos-7880.enable
  ];
in
{
  options.mobile = {
    hardware.socs.exynos-7880.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is Exynos 7880";
    };
    hardware.socs.freescale-imx6sll.enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable when SOC is Freescale i.MX 6SLL";
    };
  };

  config = mkMerge [
    {
      mobile = mkIf cfg.freescale-imx6sll.enable {
        system.system = "armv7l-linux";
      };
    }
    (mkIf anyExynos {
      mobile.kernel.structuredConfig = [
        (helpers: with helpers; {
          ARCH_EXYNOS = lib.mkDefault yes;
        })
      ];
    })
  ];
}
