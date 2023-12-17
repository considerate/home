{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        "layer" = "top";
        "modules-left" = [ "custom/nixos" "cpu" "memory" "hyprland/workspaces" ];
        "modules-center" = [ "clock" ];
        "modules-right" = [ "backlight" "pulseaudio" "bluetooth" "network" "battery" ];
        "custom/nixos" = {
          "format" = " ";
          "tooltip" = false;
          "on-click" = "rofi-powermenu";
        };
        "hyprland/workspaces" = {
          "format" = "{name} {icon}";
          "tooltip" = false;
          "all-outputs" = true;
          "format-icons" = {
            "active" = "";
            "default" = "";
          };
        };
        "clock" = {
          "format" = "<span color='#b4befe'> </span>{:%H:%M}";
          "tooltip-format" = "{:%A %Y-%m-%d}";
        };
        "backlight" = {
          "device" = "intel_backlight";
          "format" = "<span color='#b4befe'>{icon}</span> {percent}%";
          "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
        };
        "pulseaudio" = {
          "format" = "<span color='#b4befe'>{icon}</span> {volume}%";
          "format-muted" = "";
          "tooltip" = false;
          "format-icons" = {
            "headphone" = "";
            "default" = [ "" "" "󰕾" "󰕾" "󰕾" "" "" "" ];
          };
          "scroll-step" = 1;
        };
        "bluetooth" = {
          "format" = "<span color='#b4befe'></span> {status}";
          "format-disabled" = ""; # an empty format will hide the module
          "format-connected" = "<span color='#b4befe'></span> {num_connections}";
          "tooltip-format" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}   {device_address}";
        };
        "network" = {
          "interface" = "wlp2s0";
          "interval" = 2;
          "format" = "{ifname}";
          "format-wifi" = "<span color='#b4befe'> </span>{essid} {bandwidthDownBytes:>}  {bandwidthUpBytes:>}  ";
          "format-ethernet" = "{ipaddr}/{cidr} {bandwidthDownBytes:>}  {bandwidthUpBytes:>}  ";
          "format-disconnected" = "<span color='#b4befe'>󰖪 </span>No Network";
          "tooltip" = false;
        };
        "cpu" = {
          "format" = "{usage}%  ";
          "tooltip" = false;
        };
        "memory" = {
          "format" = "{}%  ";
        };
        "battery" = {
          "format" = "<span color='#b4befe'>{icon}</span> {capacity}%";
          "format-icons" = {
            default = [ " " " " " " " " " " ];
            charging = [ "󰢟 " "󱊤 " "󱊥 " "󱊦 " "󰂅 " ];
          };
          "format-charging" = "<span color='#b4befe'>{icon}</span> {capacity}%";
          "tooltip" = false;
        };
      };
    };
  };
}
