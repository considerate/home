{ pkgs, ... }:
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
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
  home.packages = [
    wallpaper_random
    pkgs.kitty
    pkgs.swww
    pkgs.cinnamon.nemo
  ];
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
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = ''
      # Monitor

      # Autostart
      exec = pkill waybar; waybar
      exec-once = swww init; wallpaper_random
      misc {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = 0 # Set to 0 to disable the default wallpaper
      }

      # Set en layout at startup

      # Input config
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          natural_scroll = true

          touchpad {
              natural_scroll = true
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {

          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgb(b4befe)
          col.inactive_border = rgb(11111b)

          layout = dwindle

          allow_tearing = false
      }


      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10

          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      master {
          new_is_master = yes
      }

      gestures {
          workspace_swipe = false
      }

      $mainMod = SUPER
      bind = $mainMod, G, fullscreen,

      # Variables
      $term = kitty
      $browser = firefox
      $editor = code
      $files = nemo
      $launcher = killall rofi || rofi -no-lazy-grab -show drun -theme launcher

      bind = $mainMod, RETURN, exec, kitty
      bind = $mainMod, Q, killactive,
      bind = $mainMod SHIFT, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, W, exec, wallpaper_random # change wallpaper
      bind = $mainMod, P, exec, $launcher
      bind = $mainMod, D, pseudo, # dwindle
      bind = $mainMod, SPACE, togglesplit, # dwindle
      bind = SUPER, RETURN, exec, run-as-service $term
      bind = SUPER SHIFT, E, exec, $editor
      bind = SUPER SHIFT, F, exec, $files
      bind = SUPER SHIFT, B, exec, $browser

      # Switch Keyboard Layouts

      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = SHIFT, Print, exec, grim -g "$(slurp)"

      # Functional keybinds
      bind =,XF86MonBrightnessDown,exec,brightnessctl set 5%-
      bind =,XF86MonBrightnessUp,exec,brightnessctl set 5%+
      bind =,XF86AudioMute,exec,amixer sset Master toggle
      bind =,XF86AudioLowerVolume,exec,amixer sset Master 5%-
      bind =,XF86AudioRaiseVolume,exec,amixer sset Master 5%+
      bind =,XF86AudioPlay,exec,playerctl play
      bind =,XF86AudioPrev,exec,playerctl previous
      bind =,XF86AudioNext,exec,playerctl next
      bind =,XF86AudioStop,exec,playerctl stop
      bind =,XF86AudioPause,exec,playerctl pause
      bind =,XF86KbdBrightnessUp,exec,kbdlight up
      bind =,XF86KbdBrightnessDown,exec,kbdlight down

      # to switch between windows in a floating workspace
      bind = SUPER,Tab,cyclenext,
      bind = SUPER,Tab,bringactivetotop,

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, j, movefocus, d
      bind = $mainMod, k, movefocus, u
      bind = $mainMod SHIFT, H, swapwindow, l
      bind = $mainMod SHIFT, L, swapwindow, r
      bind = $mainMod SHIFT, J, swapwindow, d
      bind = $mainMod SHIFT, K, swapwindow, u

      # workspaces
      # binds $mainMod + [shift +] {1..10} to [move to] workspace {1..10}
      ${builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in ''
            bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
            bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
          ''
        )
        10)}

      # Example special workspace (scratchpad)
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };
}
