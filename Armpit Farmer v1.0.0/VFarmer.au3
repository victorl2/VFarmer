#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon\vfarmer.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Auto farming Armpit Hero
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Language=1046
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MsgBoxConstants.au3>
#include <ImageSearch.au3>
#Include <WinAPI.au3>
#Include <WinAPI.au3>; to call Windows api specific functions
#include <WindowsConstants.au3>; to include Windows specific constants, such as the Windows Style Values


HotKeySet("{F1}", "Exit_program");Close the program
HotKeySet("{F2}", "Focus_program");Hides the program from the screen
HotKeySet("{F10}", "Hide");Hides the program from the screen
HotKeySet("{F9}", "Show");Shows the program above everything

global $HWD = "" ;ANDY process handler
global $y = 0, $x = 0, $ad = 0
global $WINDOW = "" , $WIDTH = 0,$HEIGHT = 0

;*EXECUÇÃO COMPLETA DA MACRO
Func Start()
   ;*Verificando se o andy esta aberto
	If Not ProcessExists("AndyConsole.exe") Then
		MsgBox(4, "Alert", "Andy must be open to run this script ! " , 10)
		Exit 0
	EndIf

	Local $r = MsgBox(4, "Alert", "Do you wanna start the application " , 10)
	If ($r <> 6) Then
		Exit 0
	EndIf

	;*Buscando foco do programa
	$HWD = WinWait("[CLASS:Qt5QWindowIcon]", "", 10)
	WinActivate($HWD)
	sleep(400)

	;Screen size info and window size info
	$WIDTH = _WinAPI_GetSystemMetrics(78)
	$HEIGHT = _WinAPI_GetSystemMetrics(79)
	$WINDOW = WinGetPos($HWD)

	;Disable Window Resize
	$style = _WinAPI_GetWindowLong($HWD, $GWL_STYLE)
	If BitXOR($style,$WS_SIZEBOX,$WS_MAXIMIZEBOX) <> BitOr($style,BitXOR($style,$WS_SIZEBOX,$WS_MAXIMIZEBOX)) Then
		_WinAPI_SetWindowLong($HWD,$GWL_STYLE,BitXOR($style,$WS_SIZEBOX,$WS_MAXIMIZEBOX))
	EndIf

	WinSetOnTop ($HWD,"",1)


	;Center the window and hides it on the screen
	WinMove( $HWD, "", $WINDOW[2]/2 , $WINDOW[3] -($HEIGHT/2) , 800 , 500 ,10  )
	AutoItSetOption ("PixelCoordMode" , 2 )
	AutoItSetOption ("MouseCoordMode" , 2 )

	Local $tipo = 0 ;0 = modo aventura, 1 = modo farming
	ConsoleWrite("Starting script main loop" & @LF )
	sleep(100)

	;SCRIPT MODO AVENTURA
	If $tipo == 0 Then
		Local $timer = TimerInit() ;inicia a contagem para sacar dinheiro no banco
		Local $total_bau = 0

		While 1
			While TimerDiff($timer) < 20000
				;Tenta abrir bau
				abre_bau()
				Sleep(50)
			WEnd

			mana_trainer()
			sleep(100)

			gerencia_banco()
			sleep(100)

			fase_bonus()
			sleep(100)

			BossSkill()
			sleep(100)

			QuestComplete()
			sleep(100)

			$timer = TimerInit()
		WEnd
	EndIf

EndFunc

;*Abre baus bonus que aparecem na tela
Func abre_bau()
	;**ABRIU O BAU
	if checkForImage() Then
		$ad += 1
	   ;*É UM BAU DE ANUNCIO ?
	   sleep(1900)
	   Local $pixel = PixelGetColor( 476, 311 , $HWD )
	   if Hex($pixel) = Hex(0x33DD88) Then
			ControlClick($HWD,"","", "left", 1 , 880, 393 )
			Sleep(31500) ;*Esperamos 35 segundos do video
			ControlSend($HWD ,"","","{ESC}");*Fecha o anuncio final do vídeo
			sleep(1000)
			ControlSend($HWD ,"","","{ESC}");*Fecha o pop de confirmacao dos cristais
	   EndIf
	   return True
	EndIf

	Return False
EndFunc

;Coletar bonus após completa um conjunto de fases (OK)
Func fase_bonus()
	$pixel = PixelGetColor(266, 353, $HWD)
	if Hex($pixel) = Hex(0xD21111) Then
		sleep(100)
		ControlClick($HWD , "","" , "left" , 1 , 242, 369);CLICK FOR ENTER STAGE
		sleep(2500)
		ControlClick($HWD , "","" , "left" , 1 , 742, 85);CLICK FOR CASH STAGE
		sleep(900)
		ControlSend($HWD, "","","{ESC}")
		sleep(900)
		ControlSend($HWD, "","","{ESC}")
		return True
	EndIf
	return False
EndFunc

;(OK)
Func gerencia_banco()
	;*Ir para o banco
	Local $pixel = PixelGetColor(161, 354,$HWD )
	if Hex($pixel) = Hex(0xC21110) Then
		sleep(1200)
		ControlClick($HWD,"","","left",1,136, 372)
		sleep(2500)
		ControlClick($HWD , "","" , "left" , 2 , 153, 342);CLICK FOR WIDTHDRAW BANK
		sleep(800)
		;*Sai do banco
		ControlSend($HWD, "","","{ESC}")
		Sleep(70)
		return True
   EndIf
   return False
EndFunc

;* Manda magia de rodar (1° Magia )
Func cast_shuriken()
   Sleep(5000)
   MouseClick("left" , 1067, 774 )
   ConsoleWrite("Casting 1st skill"  & @LF)
EndFunc


;* Usa magia meteoro (3° magia) se a mana estiver cheia
Func mana_trainer()
	Local $pixel = PixelGetColor(	461, 377,$HWD)
	Local $pixel2 = PixelGetColor(629, 361 , $HWD)

	if Hex($pixel) = Hex(0x1199DD) and Hex($pixel2) = Hex(0x551133) Then
		sleep(100)
		ControlClick($HWD , "","" , "left" , 1 , 629, 361);CLICK FOR 3rd SKILL (COLOR 0x551133)
		return True
	EndIf
	return False
EndFunc




;Local $search = _ImageSearch('bau.png', 0, $x, $y, 50 , $HWD) EXCELENTE
Func checkForImage()
	AutoItSetOption ("PixelCoordMode" , 1)
	AutoItSetOption ("MouseCoordMode" , 1 )
	Local $search =  _ImageSearchArea('images/bau800.png', 0, $WINDOW[0], $WINDOW[1], $WINDOW[2],$WINDOW[3],$x, $y,100,$HWD)
	If $search = 1 Then
		MouseClick("left",$x,$y )
		AutoItSetOption ("PixelCoordMode" , 2)
		AutoItSetOption ("MouseCoordMode" , 2)
		return True
	EndIf
	AutoItSetOption ("PixelCoordMode" , 2 )
	AutoItSetOption ("MouseCoordMode" , 2 )
   return False
EndFunc

;Cast skill to kill the stage boss
Func BossSkill()
	Local $pixel = PixelGetColor( 461, 38 , $HWD )
	Local $pixel2 = PixelGetColor(685, 359, $HWD )
	if Hex($pixel) = Hex(0xF43F11) And Hex($pixel2) = Hex(0x551123) Then
		ControlClick($HWD , "","" , "left" , 1 , 683, 360);CLICK FOR 4rd SKILL (COLOR 0x551126)
	EndIf
EndFunc


Func QuestComplete()
	Local $pixel = PixelGetColor( 747, 104 ,$HWD )
	if Hex($pixel) = Hex(0x88DD11) Then
		ControlClick($HWD, "", "","left", 1, 747, 104)
		sleep(500)
		ControlSend($HWD,"","","{ESC}")
	EndIf
EndFunc


;* Fecha o script
Func Exit_program()
	$r = MsgBox(4, "Alert", "Do you wanna exit the application ? " , 10)
	If ($r == 6) Then
		WinSetOnTop ($HWD,"",0)
		Exit 0
	EndIf
EndFunc

;Focus on the application
Func Focus_program()
	WinMove( $HWD, "", $WINDOW[2]/2 , $WINDOW[3] -($HEIGHT/2) , 800 , 500 ,10  )
	WinActivate($HWD)
EndFunc

;Hide the game window
Func Hide()
	sleep(100)
	WinSetState ( $HWD, "", @SW_HIDE)
EndFunc

;Shows the game window
Func Show()
	sleep(100)
	WinSetState ($HWD , "" , @SW_SHOW )
EndFunc

Start()
