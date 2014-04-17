--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Layout.NoBorders

import Data.List 
import XMonad.Hooks.ManageDocks
import Control.Monad (liftM2)

import Control.Monad (liftM2)
import XMonad.Util.EZConfig
import XMonad.Util.CustomKeys
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Layout.PerWorkspace
import XMonad.Hooks.DynamicLog


import XMonad.Hooks.EwmhDesktops
myManageHook = composeAll  . concat $
	[  [ className =? "Vlc"  --> viewShift "4:vlc" ]  
	,  [ className =? "Thunar"  --> viewShift "3:thunar" ]  
	,  [ title =? "New Tab - Chromium"  --> viewShift "2:chrome" ]  
	,  [ appName =? "m.facebook.com__buddylist.php"  --> viewShift "7:facebook" ]  
	,  [ className =? "XTerm"  --> viewShift "1:default" ]  
	,  [ className =? "Xmessage"  --> doFloat ]
	,  [ className =? "Zenity"  --> doFloat ]
	,  [ className =? "Transmission-gtk"  --> doShift "5:apps" ]
	,  [ className =? "Skype"  --> doShift "6:skype" ]
	,  [ title   =? "File Operation Progress"        --> doFloat ] 
	]
	where viewShift = doF . liftM2 (.) W.greedyView W.shift

myTerminal      = "xterm"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

myWorkspaces    = ["1:default","2:chrome","3:thunar","4:vlc","5:apps","6:skype","7:facebook"]

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#00aa00"
------------------------------------------------------------------------
-- Layouts:
myLayout = 	avoidStruts $
		onWorkspaces ["1:default","6:skype"] l1 $
		onWorkspaces ["3:thunar","7:facebook"] l3 $  
		l2

l3 =  smartBorders (  Mirror tiled  )
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 3 
     ratio   = 1/2
     delta   = 3/100


l1 =  smartBorders ( tiled ||| Mirror tiled ||| Full )
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 2
     ratio   = 2/3
     delta   = 3/100

l2 =  smartBorders ( Full )
------------------------------------------------------------------------

mykeys = customKeys delkeys inskeys
	where
delkeys :: XConfig l -> [(KeyMask, KeySym)]
delkeys XConfig {modMask = modm} =
           -- we're preferring Futurama to Xinerama here
           [ (modm .|. m, k) | (m, k) <- zip [0, shiftMask] [xK_w, xK_e, xK_r] ]

inskeys :: XConfig l -> [((KeyMask, KeySym), X ())]
inskeys conf@(XConfig {modMask = modm}) =
		[((mod1Mask,             xK_Down), spawn "amixer set Master 1-")
		,((mod1Mask,             xK_Up  ), spawn "amixer set Master 1+")
		, ((0            , 0x1008ff11), spawn "amixer -q set Master unmute & amixer -q set LFE unmute & amixer -q set PCM 7%-")
		-- XF86AudioRaiseVolume
		, ((0            , 0x1008ff13), spawn "amixer -q set Master unmute & amixer -q set LFE unmute & amixer -q set PCM 7%+")
		-- XF86AudioMute
		, ((0            , 0x1008ff12), spawn "amixer -q set Master toggle & amixer -q set LFE toggle")
		--  0x1008ffa9, XF86TouchpadToggle
		, ((0            , 0x1008ffa9), spawn "keyboard")
		, ((mod1Mask          	, xK_f), spawn "facebookscript")
		, ((mod1Mask          	, xK_v), spawn "chromium -app=https://gw.uma.es/webmail/src/webmail.php")
		--0x1008ff8f, XF86WebCam
		, ((0            , 0x1008ff8f), spawn "guvcview")
		--0x1008ff41, XF86Launch1
		, ((0            , 0x1008ff41), spawn "xterm -e htop")
		, ((0            , 0x1008ff46), spawn "echo 'laptop_mode' > /home/blas/scripts/superflag")
		, ((0		, 0xff61), spawn "scrot -e 'echo $f | dzen2 -p 5'" )
		,((mod1Mask,             xK_y  ), spawn "thunar_xmonad")
		,((mod1Mask,             xK_plus  ), spawn "transset-df -a --inc 0.05")
		,((mod1Mask,             xK_minus  ), spawn "transset-df -a --dec 0.05")
		,((mod1Mask,             xK_c  ), spawn "chrome_xmonad" )
		,((mod1Mask, xK_x     ), kill) --  Close the focused window
		,((mod1Mask .|. shiftMask , xK_Return  ), spawn "xterm -rv")
		,((mod1Mask,             xK_u ), spawn "devmon -u | dzen2 -p 5 -l 5")
		,((mod1Mask,             xK_d ), spawn "weather")
		,((mod1Mask,             xK_m ), spawn "echo 'modem' > /home/blas/scripts/superflag")
		,((modm, xK_b     ), sendMessage ToggleStruts)
		,((mod1Mask,		 xK_g),sendMessage $ SetStruts [] [D] )
		,((mod1Mask,             xK_r ), spawn "xterm -e /home/blas/scripts/randomsentence")
		,((mod1Mask,             xK_s ), spawn "plugmonitor")
		,((mod1Mask,             0xf1), spawn "ping -W 2 -c 5 www.google.es | dzen2")
		,((mod1Mask,             xK_o  ), spawn "chromium --app=http://www.wordreference.com")
		,((mod1Mask,             xK_i  ), spawn "chromium --app=https://translate.google.com")
		]
--------------------------------------------------------------------
myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
	[ ((modMask, button1), (\w -> focus w >> windows W.shiftMaster))]
------------------------------------------------------------------------

myStartupHook = do
	spawn ""
          --spawn "echo '^fg(yellow)Welcome to Xmonad !' | dzen2 -p 3 -fg '#a8a3f7' -bg '#3f3c6d' "
	--spawn "while [ -z '$(ps -e | grep xmobar)' ]; do sleep 1; echo; done; sleep 1; transset-df 0.75 --name xmobar;"

------------------------------------------------------------------------

-- Run xmonad with the settings you specify. No need to modify this.
--

main = xmonad $ ewmh defaults
-- main = xmonad defaults 
-- main = do
--	conf <- xmobar defaults
--	xmonad $ conf

defaults = defaultConfig {
	handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook,
	-- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

	-- hooks, layouts 
	manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig,
	layoutHook         = myLayout,
	startupHook        = myStartupHook,
    
	-- keybindings
mouseBindings      = myMouseBindings,
	keys		   = mykeys
}
