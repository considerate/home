{ pkgs, config, osConfig, ... }:
let
  wallpaper_random = pkgs.writeShellScriptBin "wallpaper_random" ''
    if command -v swww >/dev/null 2>&1; then
        swww img "$(find ~/Wallpapers/papes -type f | shuf -n1)" --transition-type simple
    fi
  '';
in
{
  imports = [
    ./waybar
  ];
  programs.wofi.enable = true;
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
    packages = [
      wallpaper_random
      pkgs.wl-clipboard
      pkgs.kitty
      pkgs.swww
    ];
    file = {
      kitty = {
        source = ./kitty.conf;
        target = "${config.xdg.configHome}/kitty/kitty.conf";
      };
    };
  };
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-right";
        offset = "22x22";
        frame_width = 2;
        frame_color = "#b4befe";
        separator_color = "frame";
        font = "Fira Code 10";
        corner_radius = 7;
        background = "#11111B";
        foreground = "#CDD6F4";
      };
    };
  };
  wayland.windowManager.hyprland =
    {
      enable = true;
      systemd.enable = true;
      settings = {
        "$mod" = "SUPER";
        exec = [
          "pkill waybar; waybar"
        ];
        exec-once = [
          "swww init; wallpaper_random"
        ];
        misc.force_default_wallpaper = 0;
        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgb(b4befe)";
          "col.inactive_border" = "rgb(11111b)";

          layout = "dwindle";

          allow_tearing = false;
        };
        # Input config
        input = {
          kb_layout = "us";

          follow_mouse = 1;

          natural_scroll = true;

          touchpad = {
            natural_scroll = true;
          };

          sensitivity = 0;
        };
        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };


        gestures = {
          workspace_swipe = false;
        };

        # to switch between windows in a floating workspace
        bind =
          let
            namedWorkspace = x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              { inherit ws x; };
            namedWorkspaces = builtins.genList
              namedWorkspace
              10;
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            workspaceBinds = builtins.concatLists
              (builtins.map
                ({ ws, x }:
                  [
                    "$mod, ${ws}, workspace, ${toString (x + 1)}"
                    "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                  ])
                namedWorkspaces);
          in

          [
            "$mod,Tab,cyclenext,"
            "$mod,Tab,bringactivetotop,"

            # Move focus with mod + arrow keys
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, j, movefocus, d"
            "$mod, k, movefocus, u"
            "$mod SHIFT, H, swapwindow, l"
            "$mod SHIFT, L, swapwindow, r"
            "$mod SHIFT, J, swapwindow, d"
            "$mod SHIFT, K, swapwindow, u"
            # Example special workspace (scratchpad)
            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"

            # Scroll through existing workspaces with mod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"

          ] ++ workspaceBinds
          ++
          # Program triggers
          [
            ''$mod, G, fullscreen,''
            ''$mod, RETURN, exec, kitty''
            ''$mod, Q, killactive,''
            ''$mod SHIFT, Q, exec, systemctl suspend''
            ''$mod SHIFT, C, killactive,''
            ''$mod SHIFT, P, exec, ${pkgs.sway-contrib.grimshot}/bin/grimshot save area "~/screenshots/screenshot-$(date +%Y-%m-%dT%H%M%S).png"''
            ''$mod, M, exit,''
            ''$mod, V, togglefloating,''
            ''$mod, W, exec, wallpaper_random # change wallpaper''
            ''$mod, P, exec, wofi --allow-images --show drun --no-actions''
            ''$mod, D, pseudo, # dwindle''
            ''$mod, SPACE, togglesplit,''
            ''$mod, RETURN, exec, run-as-service kitty''
            ''$mod SHIFT, B, exec, firefox''
            ''$mod SHIFT, F, exec, nemo''
            '', Print, exec, grim -g "$(slurp)" - | wl-copy''
            ''$mod, Print, exec, grim -g "$(slurp)"''
          ]
          ++
          # Function keys
          [
            ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
            ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
            ",XF86AudioMute,exec,amixer sset Master toggle"
            ",XF86AudioLowerVolume,exec,amixer sset Master 5%-"
            ",XF86AudioRaiseVolume,exec,amixer sset Master 5%+"
            ",XF86AudioPlay,exec,playerctl play"
            ",XF86AudioPrev,exec,playerctl previous"
            ",XF86AudioNext,exec,playerctl next"
            ",XF86AudioStop,exec,playerctl stop"
            ",XF86AudioPause,exec,playerctl pause"
            ",XF86KbdBrightnessUp,exec,kbdlight up"
            ",XF86KbdBrightnessDown,exec,kbdlight down"
          ]
        ;
        # Move/resize windows with mod + LMB/RMB and dragging
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
}
