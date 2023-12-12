Double Height, TrayDistance, InfeedHeight, PressureTime
Integer Tokens, Blocks, TokenID, BlockID, Jengas

' 放料 
Double ToTrayBlock_X, ToTrayBlock_Y, ToTrayBlock_Z
Double ToTrayToken_X, ToTrayToken_Y, ToTrayToken_Z

' 取料
Double ToInfeedBlock_X, ToInfeedBlock_Y, ToInfeedBlock_Z
Double ToInfeedToken_X, ToInfeedToken_Y, ToInfeedToken_Z


' 對齊
Double ToAlignBlock_X, ToAlignBlock_Y, ToAlignBlock_Z
Double ToAlignToken_X, ToAlignToken_Y, ToAlignToken_Z

' 疊疊樂
Double ToJengas_X, ToJengas_Y, ToJengas_Z

Boolean IsSim
Boolean IsPick

Function init
	IsSim = False
	IsPick = False
	
	Print "Start Init"
	Motor On
	Power High
	Off 8
	Tool 2
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
	
	' 吸嘴時間
	PressureTime = .1

	TrayDistance = 30.0

	' Tray上高度
	InfeedHeight = 50.0
	
	If IsSim Then
		Print "Is Simulator Now"
		
		Speed 50
		Accel 50, 50
		SpeedS 1000
		AccelS 5000
		
		Height = 6.0
			
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
	
		Height = 6.0

		' 相對local距離
		' 放料 
		ToTrayBlock_X = 0.919
		ToTrayBlock_Y = 56.3
		ToTrayBlock_Z = 10.0
		
		ToTrayToken_X = 0.798
		ToTrayToken_Y = 86.750
		ToTrayToken_Z = 10.0
		
		' 取料
		ToInfeedBlock_X = 127.713
		ToInfeedBlock_Y = 1.248
		ToInfeedBlock_Z = 10.0 + Height
		
		ToInfeedToken_X = 125.272
		ToInfeedToken_Y = 27.742
		ToInfeedToken_Z = 10.0 + Height
		
		' 對齊
		ToAlignBlock_X = 127.401
		ToAlignBlock_Y = 121.221
		ToAlignBlock_Z = 10.0 + Height
		
		ToAlignToken_X = 124.466
		ToAlignToken_Y = 147.936
		ToAlignToken_Z = 10.0 + Height
		
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
	
	TrayBlock = origin + XY(ToTrayBlock_X, ToTrayBlock_Y, ToTrayBlock_Z, 0) /1
	TrayToken = origin + XY(ToTrayToken_X, ToTrayToken_Y, ToTrayToken_Z, 0) /1
	
	InfeedBlock = origin + XY(ToInfeedBlock_X, ToInfeedBlock_Y, ToInfeedBlock_Z, 0) /1
	InfeedToken = origin + XY(ToInfeedToken_X, ToInfeedToken_Y, ToInfeedToken_Z, 0) /1
	
	AlignBlock = origin + XY(ToAlignBlock_X, ToAlignBlock_Y, ToAlignBlock_Z, 0) /1
	AlignToken = origin + XY(ToAlignToken_X, ToAlignToken_Y, ToAlignToken_Z, 0) /1
	
	JengasPoint = origin + XY(ToJengas_X, ToJengas_Y, ToJengas_Z, 0) /1
	
	safepoint = origin + XY(50, 70, 120, 0) /1
	
	Print "Go safepoint"
	Go safepoint /1
	
	Print "Is init"
	
Fend

Function test
	init()

	Move JengasPoint +Z(3) /1


Fend

Function Pick_Infeed_Block
	
	'Pick Block from Infeed
	Print "Picking Block from Infeed. Block ID = ", Blocks
	Move InfeedBlock +Z(Blocks * Height + InfeedHeight) /1 CP
	Move InfeedBlock +Z(Blocks * Height) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedBlock +Z(1 + (Blocks * Height)) /1
	Move InfeedBlock +X(-10) +Y(5) +Z(Blocks * Height + InfeedHeight) /1 CP
	
Fend

Function Alignment_Block
	'Alignment Block
	Print "Aligning Block. Block ID = ", Blocks
    Move AlignBlock +X(-10) +Y(10) +Z(50) /1 CP
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
	Move TrayBlock +X(Blocks * TrayDistance) +Z(30) /1
	Move TrayBlock +X(Blocks * TrayDistance) /1
	Off 8
	Wait PressureTime
	Move TrayBlock +X(Blocks * TrayDistance) +Z(30) /1 CP
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
	Move InfeedToken +Z(Tokens * Height + InfeedHeight) /1 CP
	Move InfeedToken +Z(Tokens * Height) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedToken +Z(1 + (Tokens * Height)) /1
	Move InfeedToken +X(-10) +Z(Tokens * Height + InfeedHeight) /1 CP
	
Fend

Function Alignment_Token
	'Alignment Block
	Print "Aligning Token. Token ID = ", Tokens
    Move AlignToken +X(-10) +Z(50) /1 CP
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
	Move TrayToken +X(Tokens * TrayDistance) +Z(30) /1
	Move TrayToken +X(Tokens * TrayDistance) /1
	Off 8
	Wait PressureTime
	Move TrayToken +X(Tokens * TrayDistance) +Z(30) /1 CP
Fend

Function Token_
	For TokenID = Tokens To 0 Step -1
		Pick_Infeed_Token()
	 	Alignment_Token()
	 	Place_Tray_Token()
	 	Tokens = Tokens - 1
	Next TokenID
Fend

Function Jenga
	Integer i
	For i = 5 To 0 Step -1
		Pick_Infeed_Block()

		Blocks = Blocks - 1
		Move JengasPoint +Z(Jengas * Height + TrayDistance) /1 CP
		Move JengasPoint +Z(Jengas * Height) /1
		Off 8
		Wait PressureTime
		Move JengasPoint +Z(Jengas * Height + Height) /1 CP
		Jengas = Jengas + 1
	
		Pick_Infeed_Token()

		Tokens = Tokens - 1
		Move JengasPoint +Z(Jengas * Height + TrayDistance) /1 CP
		Move JengasPoint +Z(Jengas * Height) /1
		Off 8
		Wait PressureTime
		Move JengasPoint +Z(Jengas * Height + Height) /1 CP
		Jengas = Jengas + 1
	Next i
Fend

Function main
	init()
	If IsPick Then
		Print "Pick And Place"
		Block_()
		Token_()
	Else
		Print "Jenga"
		Jenga()
	EndIf
	Go safepoint /1
Fend

