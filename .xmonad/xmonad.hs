import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Operations (unGrab)

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns

import XMonad.Hooks.EwmhDesktops

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.xmonad/xmobar.hs" (pure xmXmobarPP)) defToggleStrutsKey
     $ xmconfig

xmconfig = def
    { modMask = mod4Mask
    , layoutHook = xmLayout
    , startupHook = xmStart
    , manageHook = xmManage
    , logHook = dynamicLogWithPP xmXmobarPP
    , borderWidth = 2
    , normalBorderColor = "#444444"
    , focusedBorderColor = "#6387a5"
    }

    `additionalKeys`

    [ ((mod4Mask, xK_Return), spawn "alacritty")
    , ((mod4Mask, xK_d), spawn "dmenu_run -fn 'Terminus-8' -nb '#000000' -nf '#8da563' -sb '#a59c63' -sf '#000000'")
    , ((mod4Mask, xK_q), kill)
    , ((mod4Mask, xK_p), spawn "maim -s | xclip -selection clipboard -t image/png")
    ]

xmManage :: ManageHook
xmManage = composeAll [ isDialog --> doFloat ]

xmLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
    where
        threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
        tiled    = Tall nmaster delta ratio
        nmaster  = 1
        ratio    = 1/2
        delta    = 3/100

xmXmobarPP :: PP
xmXmobarPP = def
    { ppSep             = magenta " * "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Bottom" "#8da563" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    , ppVisible         = wrap "(" ")" . blue
    , ppLayout          = red
    }
  where
    formatFocused   = wrap (white    "(") (white    ")") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "(") (lowWhite ")") . blue    . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#a56383" ""
    blue     = xmobarColor "#6387a5" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#a59c63" ""
    red      = xmobarColor "#a57b63" ""
    lowWhite = xmobarColor "#888888" ""

xmStart :: X ()
xmStart = do
    spawnOnce "xsetroot -solid black"
    spawnOnce "setxkbmap -layout lv,ru -option grp:alt_shift_toggle"
