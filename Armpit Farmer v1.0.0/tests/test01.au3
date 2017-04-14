#include <MsgBoxConstants.au3>
#Include <WinAPI.au3>



$HWD = WinWait("[CLASS:Qt5QWindowIcon]", "", 10)
WinActivate($HWD)
sleep(1000)
WinSetState($HWD,"",@SW_SHOW)

;~ WinSetState ( $HWD, "text", @SW_HIDE)
;~ ControlClick($HWD, "", "" , "left", 1 , 175, 545 )
;WinMove( $HWD, "", $WINDOW[2]/2 , $WINDOW[3] -($HEIGHT/2) , 800 , 500 ,10  )
;WinSetState ( $HWD, "text", @SW_HIDE)


AutoItSetOption ("PixelCoordMode" , 2 )
AutoItSetOption ("MouseCoordMode" , 2 )

Sleep(100)
;~ ControlClick($HWD , "","" , "left" , 1 , 137, 375);CLICK FOR ENTER BANK
;~ ControlClick($HWD , "","" , "left" , 1 , 153, 342);CLICK FOR WIDTHDRAW BANK
;~ ControlClick($HWD , "","" , "left" , 1 , 242, 369);CLICK FOR ENTER STAGE
;~ ControlClick($HWD , "","" , "left" , 1 , 742, 85);CLICK FOR CASH STAGE
;~ ControlClick($HWD , "","" , "left" , 1 , 629, 361);CLICK FOR 3rd SKILL (COLOR 0x551133)
;~ ControlClick($HWD , "","" , "left" , 1 , 683, 360);CLICK FOR 4rd SKILL (COLOR 0x551126)


;0x420B07
$pixel = PixelGetColor(	461, 377,$HWD)
$pixel2 = PixelGetColor(629, 361 , $HWD)

if Hex($pixel) = Hex(0x1199DD) and Hex($pixel2) = Hex(0x551133) Then
	sleep(100)
	ControlClick($HWD , "","" , "left" , 1 , 629, 361);CLICK FOR 3rd SKILL (COLOR 0x551133)
EndIf









