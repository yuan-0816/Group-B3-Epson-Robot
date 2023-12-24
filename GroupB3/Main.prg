#include "DefineVar.inc"

Function init
	IsSim = False
	
	Print "Start Init"
	Motor On
	Power High
	Off 8
	Tool 2	' ["1": "校點z=100", "2": "實際z=95"]
	LocalClr 1
	
	Jengas = 0
	
	If IsPick Then
		' [0 1 2]
		Blocks = 2
		Tokens = 2
	Else
		' [0 1 2 3 4 5]
		Blocks = 5
		Tokens = 5
	EndIf
	
	If IsSim Then
		Print "Is Simulator Now"
		
		Speed 50
		Accel 50, 50
		
		' Move
		SpeedS 1000
		AccelS 5000
		
			
		' 相對local距離
		' 放料 
		ToTrayBlock_X = 0.0
		ToTrayBlock_Y = 55.0
		ToTrayBlock_Z = 10.0
		
		ToTrayToken_X = 0
		ToTrayToken_Y = 85.0
		ToTrayToken_Z = 10.0
		
		' 取料
		ToInfeedBlock_X = 128.50
		ToInfeedBlock_Y = 0
		ToInfeedBlock_Z = 10.0 + Height
		
		ToInfeedToken_X = 126.162
		ToInfeedToken_Y = 26.34
		ToInfeedToken_Z = 10.0 + Height
		
		' 對齊
		ToAlignBlock_X = 128.50
		ToAlignBlock_Y = 119.0
		ToAlignBlock_Z = 10.0 + Height
		
		ToAlignToken_X = 126.162
		ToAlignToken_Y = 145.34
		ToAlignToken_Z = 10.0 + Height
		
		' 疊疊樂
		ToJengas_X = 118.0
		ToJengas_Y = 123.0
		ToJengas_Z = 10.0 + Height
		
		local_origin = local_origin /NF
		local_X = local_X /NF
		local_Y = local_Y /NF
		Local 1, local_origin, local_X, local_Y, X ' simulator
		origin = local_origin @1 ' simulator
	Else
		Print "Is Real World Now"

		Speed 50
		Accel 50, 50
		SpeedS 800
		AccelS 4000
	

		' 相對local距離
		' 取料
		ToInfeedBlock_X = 127.462
		ToInfeedBlock_Y = -0.852
		ToInfeedBlock_Z = 10.0 + Height
		
		ToInfeedToken_X = 125.071
		ToInfeedToken_Y = 26.192
		ToInfeedToken_Z = 10.0 + Height
		
		' 對齊
		ToAlignBlock_X = 128.200
		ToAlignBlock_Y = 119.471
		ToAlignBlock_Z = 10.0 + Height
		
		ToAlignToken_X = 125.815
		ToAlignToken_Y = 145.936
		ToAlignToken_Z = 10.0 + Height
		
		
		' 放料 
		ToTrayBlock_X = 0.668
		ToTrayBlock_Y = 55.700
		ToTrayBlock_Z = 10.0
		
		ToTrayToken_X = 0.798
		ToTrayToken_Y = 86.050
		ToTrayToken_Z = 10.0
		
		
		' 疊疊樂
		ToJengas_X = 118.0
		ToJengas_Y = 123.0
		ToJengas_Z = 10.0 + Height
		
		
		RealLocalOrigin = RealLocalOrigin /NF
		RealLocalX = RealLocalX /NF
		RealLocalY = RealLocalY /NF
		Local 1, RealLocalOrigin, RealLocalX, RealLocalY, X ' real word
		origin = RealLocalOrigin @1 ' real word
	EndIf
	
	ArcPointX = ToTrayBlock_X + (TrayDistance * 2) + 30
	ArcPointY = (ToInfeedBlock_Y + ToAlignBlock_Y) /2
	ArcPointHeight = 10.0
	
	InfeedBlock = origin + XY(ToInfeedBlock_X, ToInfeedBlock_Y, ToInfeedBlock_Z, 0) /1
	InfeedToken = origin + XY(ToInfeedToken_X, ToInfeedToken_Y, ToInfeedToken_Z, 0) /1
	
	AlignBlock = origin + XY(ToAlignBlock_X, ToAlignBlock_Y, ToAlignBlock_Z, 0) /1
	AlignToken = origin + XY(ToAlignToken_X, ToAlignToken_Y, ToAlignToken_Z, 0) /1
		
	TrayBlock = origin + XY(ToTrayBlock_X, ToTrayBlock_Y, ToTrayBlock_Z, 0) /1
	TrayToken = origin + XY(ToTrayToken_X, ToTrayToken_Y, ToTrayToken_Z, 0) /1
	
	JengasPoint = origin + XY(ToJengas_X, ToJengas_Y, ToJengas_Z, 0) /1
	
	ArcPoint = origin + XY(ArcPointX, ArcPointY, ArcPointHeight, 0) /1
	
		
	
	
	If IsPick Then
		StartPoint = InfeedBlock + XY(0, 0, Height * 3 + InfeedHeight, 0) /1
		EndPoint = TrayToken + XY(0, 0, InfeedHeight, 0) /1
	Else
		StartPoint = InfeedBlock + XY(0, 0, Height * 6 + InfeedHeight, 0) /1
		EndPoint = JengasPoint + XY(0, 0, 12 * Height + 10, 0) /1
	EndIf
	
	safepoint = origin + XY(50, 70, 120, 0) /1
	
Fend

Function Offset_pos
	init()
	Go safepoint /1
	Go StartPoint /1
	
	
	
	Move InfeedBlock +Z(2 * Height + InfeedHeight) /1 CP
	Move InfeedBlock +Z(2 * Height) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedBlock +Z(1 + (Blocks * Height)) /1
	
	Move InfeedBlock +X(-10) +Y(5) +Z(Blocks * 2 + InfeedHeight) /1 CP
	
	
	Arc ArcPoint /1, AlignBlock +Z(InfeedHeight) /1 CP
	
    'Move AlignBlock +X(-10) +Y(10) +Z(50) /1 CP

	Move AlignBlock /1
	Off 8
	'Move AlignBlock +X(10) /1
	Move AlignBlock +X(10) +Y(-5) /1 CP
	Move AlignBlock +X(10) +Y(-5) +Z(5) /1 CP
	Move AlignBlock +Z(5) /1 CP
	Move AlignBlock /1 CP
	On 8
	Wait PressureTime
	Move AlignBlock +X(-10) +Y(10) +Z(20) /1 CP
	
	
	
	
	
	'Tool 1
	'Go safepoint /1
	'Go ArcPoint +Z(0) /1
	
Fend

Function init_position
	init()
	
	Print "Go StartPoint"
	Go safepoint /1
	Go StartPoint /1
	
	
	Print "Is init"

	'Arc origin + XY(100, 70, 120, 0) /1, origin + XY(50, 20, 90, 0) /1
	'Move ArcPoint +Z(5) /1


Fend

Function ChangeSpeedFast
	If IsPick Then
		' Go
	    Speed 100
		Accel 100, 100
		
		' Move, Arc
		SpeedS 2000
		AccelS 25000
	Else
		SpeedS 2000
		AccelS 25000
	EndIf
Fend

Function ChangeSpeedSlow
	' Go
    Speed 50
	Accel 50, 50
	
	' Move
	SpeedS 800
	AccelS 5000

Fend

Function Pick_Infeed_Block
	
	Print "Picking Block from Infeed. Block ID = ", Blocks
	If IsPick Then
		If Blocks = 2 Then
			ChangeSpeedSlow()
		Else
			ChangeSpeedFast()
		EndIf
	Else
		If Blocks = 5 Then
			ChangeSpeedSlow()
		Else
			ChangeSpeedFast()
		EndIf
	EndIf


	Move InfeedBlock +Z(Blocks * Height + InfeedHeight) /1 CP
	
	ChangeSpeedSlow()
	Move InfeedBlock +Z(Blocks * Height) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedBlock +Z(1 + (Blocks * Height)) /1
	
	Move InfeedBlock +X(-10) +Y(5) +Z(Blocks * Height + InfeedHeight + 10) /1 CP
	
	 
Fend

Function Alignment_Block
	'Alignment Block
	Print "Aligning Block. Block ID = ", Blocks
	
	ArcPointHeight = Height * Blocks + InfeedHeight
	ArcPoint = origin + XY(ArcPointX, ArcPointY, ArcPointHeight, 0) /1
	
	ChangeSpeedFast()
	Arc ArcPoint /1, AlignBlock +X(-5) +Y(5) /1 CP
	
    'Move AlignBlock +X(-10) +Y(10) +Z(50) /1 CP
    
    ChangeSpeedSlow()
	Move AlignBlock /1
	Off 8
	Move AlignBlock +X(10) /1
	Move AlignBlock +X(10) +Y(-5) /1 CP
	Move AlignBlock +X(10) +Y(-5) +Z(5) /1 CP
	Move AlignBlock +Z(5) /1 CP
	Move AlignBlock /1 CP
	On 8
	Wait PressureTime
	Move AlignBlock +X(-10) +Y(10) +Z(20) /1 CP
Fend

Function Place_Tray_Block
	'Tray Block
	Print "Placing Block in Tray. Block Position ID = ", Blocks
	ChangeSpeedFast()
	Move TrayBlock +X(Blocks * TrayDistance) +Z(InfeedHeight) /1 CP
	ChangeSpeedSlow()
	Move TrayBlock +X(Blocks * TrayDistance) /1 CP
	Off 8
	Wait PressureTime
	Move TrayBlock +X(Blocks * TrayDistance) +Z(InfeedHeight) /1 CP
Fend

Function Block_
	For BlockID = Blocks To 0 Step -1
		Pick_Infeed_Block()
		Alignment_Block()
		Place_Tray_Block()
		Blocks = Blocks - 1
	Next BlockID
Fend


Function Pick_Infeed_Token
	'Pick Block from Infeed
	Print "Picking Token from Infeed. Token ID = ", Tokens
	
	ChangeSpeedFast()
	Move InfeedToken +Z(Tokens * Height + InfeedHeight) /1 CP
	ChangeSpeedSlow()
	Move InfeedToken +Z(Tokens * Height) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedToken +Z(1 + (Tokens * Height)) /1
	Move InfeedToken +X(-10) +Z(Tokens * Height + InfeedHeight) /1 CP
	
Fend

Function Alignment_Token
	'Alignment Block
	Print "Aligning Token. Token ID = ", Tokens
	ChangeSpeedFast()
    Move AlignToken +X(-10) +Z(InfeedHeight) /1 CP
    ChangeSpeedSlow()
	Move AlignToken /1
	Off 8
	Move AlignToken +X(5) /1 CP
	Move AlignToken +X(5) +Z(5) /1 CP
	Move AlignToken +Z(5) /1 CP
	Move AlignToken /1 CP
	On 8
	Wait PressureTime
	Move AlignToken +X(-10) +Z(20) /1 CP
Fend

Function Place_Tray_Token
	'Tray Block
	Print "Placing Token in Tray. Token Position ID = ", Tokens
	ChangeSpeedFast()
	Move TrayToken +X(Tokens * TrayDistance) +Z(InfeedHeight) /1 CP
	ChangeSpeedSlow()
	Move TrayToken +X(Tokens * TrayDistance) /1 CP
	Off 8
	Wait PressureTime
	Move TrayToken +X(Tokens * TrayDistance) +Z(InfeedHeight) /1 CP
Fend

Function Token_
	For TokenID = Tokens To 0 Step -1
		Pick_Infeed_Token()
	 	Alignment_Token()
	 	Place_Tray_Token()
	 	Tokens = Tokens - 1
	Next TokenID
Fend

Function PickAndPlace
	Print "Pick And Place"
	Block_()
	Token_()
Fend

Function Jenga
	Print "Jenga"
	Integer i
	Double JengaHeight
	JengaHeight = 10.0
	For i = 5 To 0 Step -1
		Pick_Infeed_Block()

		Blocks = Blocks - 1
		ChangeSpeedFast()
		
		ArcPointHeight = 5.0 + Height * Blocks
		ArcPoint = origin + XY(ArcPointX, ArcPointY, ArcPointHeight, 0) /1
		Arc ArcPoint /1, JengasPoint +Z(Jengas * Height + InfeedHeight) /1 CP
		'Move JengasPoint +Z(Jengas * Height + InfeedHeight) /1 CP
		
		ChangeSpeedSlow()
		Move JengasPoint +Z(Jengas * Height) /1
		Off 8
		Wait PressureTime
		Move JengasPoint +Z(Jengas * Height + JengaHeight) /1 CP
		Jengas = Jengas + 1
	
		Pick_Infeed_Token()

		Tokens = Tokens - 1
		ChangeSpeedFast()
		Move JengasPoint +Z(Jengas * Height + InfeedHeight) /1 CP
		ChangeSpeedSlow()
		Move JengasPoint +Z(Jengas * Height) /1
		Off 8
		Wait PressureTime
		Move JengasPoint +Z(Jengas * Height + JengaHeight) /1 CP
		Jengas = Jengas + 1
	Next i
Fend

Function Back
	Go safepoint /1
	Integer i, BackBlock, BackToken, result
	If IsPick Then
		For i = 2 To 0 Step -1
			Move TrayBlock +X(i * TrayDistance) +Z(InfeedHeight) /1 CP
			Move TrayBlock +X(i * TrayDistance) /1 CP
			On 8
			Wait PressureTime
			Move TrayBlock +X(i * TrayDistance) +Z(InfeedHeight) /1
			Move InfeedBlock +X(-5) +Y(3) +Z((2 - i) * Height + 3) /1
			Off 8
			Wait PressureTime
		Next i
		For i = 2 To 0 Step -1
			Move TrayToken +X(i * TrayDistance) +Z(InfeedHeight) /1 CP
			Move TrayToken +X(i * TrayDistance) /1 CP
			On 8
			Wait PressureTime
			Move TrayToken +X(i * TrayDistance) +Z(InfeedHeight) /1
			Move InfeedToken +X(-5) +Z((2 - i) * Height + 3) /1
			Off 8
			Wait PressureTime
		Next i
	Else
		BackBlock = 0
		BackToken = 0
		For i = 11 To 0 Step -1
			result = i Mod 2
			
			Move JengasPoint +Z(11 * Height + InfeedHeight) /1 CP
			Move JengasPoint +Z(i * Height) /1 CP
			On 8
			Wait PressureTime
			Move JengasPoint +Z(i * Height + InfeedHeight) /1 CP


			If result = 1 Then
				Move InfeedToken +X(-50) +Y(3) +Z(11 * Height + InfeedHeight) /1
				Move InfeedToken +X(-50) +Y(3) +Z(BackToken * Height + 3 - 10) /1
				Off 8
				Wait PressureTime
				Move InfeedToken +X(-50) +Y(3) +Z(11 * Height + InfeedHeight) /1
				BackToken = BackToken + 1
						
			Else
				Move InfeedBlock +X(-50) +Z(11 * Height + InfeedHeight) /1
				Move InfeedBlock +X(-50) +Z(BackBlock * Height + 3 - 10) /1
				Off 8
				Wait PressureTime
				Move InfeedBlock +X(-50) +Z(11 * Height + InfeedHeight) /1
				BackBlock = BackBlock + 1
			EndIf
		Next i
	EndIf

	Go safepoint /1
Fend

Function main
	init()

	Do While True
		
		'Pick and place
		If Sw(WHITE) = True Then
			PickAndPlace()
		EndIf
		
		' Jenga
		If Sw(BLUE) = True Then
			Jenga()
		EndIf
	
		' Pick and place init
		If Sw(green) = True Then
			IsPick = True
			'init()
			init_position()
		EndIf
		
		' Jenga init
		If Sw(ORANGE) = True Then
			IsPick = False
'			init()
			init_position()
		EndIf
		
		If Sw(RED) = True Then
			Back()
		EndIf
		
		
	Loop
	
Fend

