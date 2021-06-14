{-# LANGUAGE TupleSections #-}
import           Data.Foldable                (traverse_)
import           Data.Ratio                   ((%))
import           Graphics.X11.ExtraTypes.XF86
import           Numeric
import           System.Environment           (getEnv, setEnv)
import           System.IO                    (hPutStrLn)
import           XMonad
import           XMonad.Actions.SpawnOn       (spawnOn)
import           XMonad.Config.Desktop
import           XMonad.Core
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops hiding (fullscreenEventHook)
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers   (composeOne, doFullFloat,
                                               isFullscreen, (-?>))
import           XMonad.Layout
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Decoration
import           XMonad.Layout.LayoutModifier
import           XMonad.Layout.Master
import           XMonad.Layout.Named          (named)
import           XMonad.Layout.NoBorders
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Simplest
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.StackSet
import           XMonad.Util.EZConfig         (additionalKeys, additionalKeysP)
import           XMonad.Util.Run


takeScreenShot =
  spawn "date -Iseconds | xargs -I{} import \"$HOME/screenshots/screenshot-{}.png\""

keyBindings sessionId =
  [ ((0, xF86XK_AudioLowerVolume), spawn "amixer sset Master 5%-")
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer sset Master 5%+")
  , ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle")
  , ((0, xF86XK_MonBrightnessUp),  spawn "xbacklight -inc 5")
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
  , ((0, xF86XK_KbdBrightnessUp),  spawn "kbdlight up")
  , ((0, xF86XK_KbdBrightnessDown), spawn "kbdlight down")
  , ((mod4Mask, xK_w), spawn "next")
  , ((mod4Mask, xK_p), spawn "rofi -show combi")
  , ((mod4Mask .|. shiftMask, xK_Return), spawn "kitty")
  , ((mod4Mask .|. shiftMask, xK_p), takeScreenShot)
  , ((0, xK_F5), takeScreenShot)
  , ((mod4Mask .|. controlMask, xK_r), spawn "true && systemctl reboot")
  , ((mod4Mask .|. controlMask, xK_l), safeSpawn "loginctl" ["terminate-session", sessionId])
  , ((mod4Mask .|. controlMask, xK_h), spawn "true && systemctl hybrid-sleep")
  ]

layoutTall = Tall 1 (3/100) (1/2)
layoutSpiral = spiral (125 % 146)
layoutWide = Mirror (Tall 1 (3/100) (3/5))
layoutFull = Full


layouts = avoidStruts $ gaps $ noBorders $ layoutSpiral ||| layoutTall ||| layoutWide ||| layoutFull

run_ibus = do
  safeSpawn "ibus-daemon" ["--xim"]
  setEnv "GLFW_IM_MODULE" "ibus"
  setEnv "GTK_IM_MODULE" "ibus"

highDPISettings = do
  setEnv "GDK_SCALE" "2"
  setEnv "GDK_DPI_SCALE" "0.5"

main = do
  run_ibus
  highDPISettings
  xmproc <- spawnPipe "xmobar ~/.xmobarrc"
  sessionId <- getEnv "XDG_SESSION_ID"
  xmonad $ fullscreenSupport $ docks $ desktopConfig
    { modMask = mod4Mask
    , layoutHook = layouts
    , terminal = "st"
    , logHook = dynamicLogWithPP (xmobarPPConfig xmproc)
    , borderWidth = 0
    , manageHook = manageHook desktopConfig <+> (isFullscreen --> doFullFloat)
    , handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook
    } `additionalKeys` keyBindings sessionId

gaps = spacingRaw True (Border 0 0 0 0) False (Border 12 12 12 12) True

xmobarPPConfig h = xmobarPP
    { ppHidden = xmobarColor (disabledColor base16Ocean) "" --tag color
    , ppCurrent = xmobarColor (lightForegroundColor base16Ocean) ""
    , ppOutput = hPutStrLn h           --tag list and window title
    , ppTitle = xmobarColor (lightForegroundColor base16Ocean) "" . shorten 60 --window title color
    , ppLayout = const ""
    }

backgroundColor = base00
lighterBackgroundColor = base01
selectionBackgroundColor = base02
disabledColor = base03
darkForegroundColor = base04
foregroundColor = base05
lightForegroundColor = base06
lightBackgroundColor = base07
variableColor = base08
primitivesColor = base09
searchColor = base0A
stringColor = base0B
escapeColor = base0C
functionColor = base0D
keywordColor = base0E
deprecatedColor = base0F

red = base08 base16Ocean
orange = base09 base16Ocean
yellow = base0A base16Ocean
green = base0B base16Ocean
cyan = base0C base16Ocean
blue = base0D base16Ocean
pink = base0E base16Ocean
brown = base0F base16Ocean

data Base16 = Base16
  { base00 :: String
  , base01 :: String
  , base02 :: String
  , base03 :: String
  , base04 :: String
  , base05 :: String
  , base06 :: String
  , base07 :: String
  , base08 :: String
  , base09 :: String
  , base0A :: String
  , base0B :: String
  , base0C :: String
  , base0D :: String
  , base0E :: String
  , base0F :: String
  }

base16Ocean = Base16
  { base00 = "#2b303b"
  , base01 = "#343d46"
  , base02 = "#4f5b66"
  , base03 = "#65737e"
  , base04 = "#a7adba"
  , base05 = "#c0c5ce"
  , base06 = "#dfe1e8"
  , base07 = "#eff1f5"
  , base08 = "#bf616a"
  , base09 = "#d08770"
  , base0A = "#ebcb8b"
  , base0B = "#a3be8c"
  , base0C = "#96b5b4"
  , base0D = "#8fa1b3"
  , base0E = "#b48ead"
  , base0F = "#ab7967"
  }

