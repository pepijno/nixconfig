{ config, pkgs, ... }:

pkgs.writeShellScriptBin "start-trayer" ''
  ${pkgs.trayer}/bin/trayer \
    -l \
    --monitor 2 \
    --edge top \
    --align right \
    --widthtype request \
    --padding 7 \
    --iconspacing 10 \
    --SetDockType true \
    --SetPartialStrut true \
    --expand true \
    --transparent true \
    --alpha 35 \
    --tint 0x2B2E37  \
    --height 29 \
    --distance 5 &
''
