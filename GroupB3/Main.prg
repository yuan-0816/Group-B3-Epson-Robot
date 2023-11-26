Double TokenHeight, BlockHeight, TrayDistance, InfeedHeight, PressureTime
Integer Tokens, Blocks, TokenID, BlockID

' ��� 
Double ToTrayBlock_X, ToTrayBlock_Y, ToTrayBlock_Z
Double ToTrayToken_X, ToTrayToken_Y, ToTrayToken_Z

' ����
Double ToInfeedBlock_X, ToInfeedBlock_Y, ToInfeedBlock_Z
Double ToInfeedToken_X, ToInfeedToken_Y, ToInfeedToken_Z


' ���
Double ToAlignBlock_X, ToAlignBlock_Y, ToAlignBlock_Z
Double ToAlignToken_X, ToAlignToken_Y, ToAlignToken_Z

Boolean IsSim

Function init
	Print "Start Init"
	IsSim = False
	Motor On
	Power High
	Speed 20
	Accel 10, 10
	SpeedS 200
	AccelS 1000
	Off 8
	Tool 2
	LocalClr 1
	
	' 0 1 2
	Blocks = 2
	Tokens = 2
	
	' �l�L�ɶ�
	PressureTime = .3
	
	' ����
	BlockHeight = 6.0
	TokenHeight = 6.0

	TrayDistance = 30.0
	InfeedHeight = 50.0
	
	If IsSim Then
		Print "Is Simulator Now"
		' �۹�local�Z��
		' ��� 
		ToTrayBlock_X = 0.0
		ToTrayBlock_Y = 55.0
		ToTrayBlock_Z = 10.0
		
		ToTrayToken_X = 0
		ToTrayToken_Y = 85.0
		ToTrayToken_Z = 10.0
		
		' ����
		ToInfeedBlock_X = 128.50
		ToInfeedBlock_Y = 0
		ToInfeedBlock_Z = 10.0 + BlockHeight
		
		ToInfeedToken_X = 126.162
		ToInfeedToken_Y = 26.34
		ToInfeedToken_Z = 10.0 + TokenHeight
		
		' ���
		ToAlignBlock_X = 128.50
		ToAlignBlock_Y = 119.0
		ToAlignBlock_Z = 10.0 + BlockHeight
		
		ToAlignToken_X = 126.162
		ToAlignToken_Y = 145.34
		ToAlignToken_Z = 10.0 + TokenHeight
		
		local_origin = local_origin /NF
		local_X = local_X /NF
		local_Y = local_Y /NF
		Local 1, local_origin, local_X, local_Y, X ' simulator
		origin = local_origin @1 ' simulator
	Else
		Print "Is Real World Now"
		' �۹�local�Z��
		' ��� 
		ToTrayBlock_X = 0.0 - 0.38
		ToTrayBlock_Y = 55.0 - 1.8
		ToTrayBlock_Z = 10.0
		
		ToTrayToken_X = 0 - 0.650
		ToTrayToken_Y = 85.0 - 2.6
		ToTrayToken_Z = 10.0
		
		' ����
		ToInfeedBlock_X = 128.50
		ToInfeedBlock_Y = 0 - 0.35
		ToInfeedBlock_Z = 10.0 + BlockHeight
		
		ToInfeedToken_X = 126.162 - 0.399
		ToInfeedToken_Y = 26.34 - 1.25
		ToInfeedToken_Z = 10.0 + TokenHeight
		
		' ���
		ToAlignBlock_X = 128.50 - 0.299
		ToAlignBlock_Y = 119.0 - 3.25
		ToAlignBlock_Z = 10.0 + BlockHeight
		
		ToAlignToken_X = 126.162 - 0.598
		ToAlignToken_Y = 145.34 - 4.25
		ToAlignToken_Z = 10.0 + TokenHeight
		
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
	
	safepoint = origin + XY(50, 70, 120, 0) /1

	'Go underworkcell

	'Wait .5
	
	Print "Go safepoint"
	Go safepoint /1
	
Fend

Function test
	Integer i
	init()
	For i = 2 To 0 Step -1
		Move InfeedBlock +Z(i * BlockHeight) /1
		Move InfeedToken +Z(i * BlockHeight) /1
		Move AlignBlock /1
		Move AlignToken /1
		Move TrayBlock +X(i * TrayDistance) /1
		Move TrayToken +X(i * TrayDistance) /1
		Go safepoint /1
	Next i
Fend

Function realworldtest
	init()
	Move InfeedBlock /1
	On 8
	Wait 1
	Move InfeedBlock +Z(30) /1
	Move TrayBlock +Z(30) /1
	Move TrayBlock /1
	Off 8
		
Fend

Function Pick_Infeed_Block
	
	'Pick Block from Infeed
	Print "Picking Block from Infeed. Block ID = ", Blocks
	Move InfeedBlock +Z(Blocks * BlockHeight + InfeedHeight) /1 CP
	Move InfeedBlock +Z(Blocks * BlockHeight) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedBlock +Z(1 + (Blocks * BlockHeight)) /1
	Move InfeedBlock +X(-3) +Y(3) +Z(Blocks * BlockHeight + InfeedHeight) /1 CP
	
Fend

Function Alignment_Block
	'Alignment Block
	Print "Aligning Block. Block ID = ", Blocks
    Move AlignBlock +Z(50) /1 CP
	Move AlignBlock /1
	Off 8
	Move AlignBlock +X(6) +Y(-6) /1 CP
	Move AlignBlock +X(6) +Y(-6) +Z(5) /1 CP
	Move AlignBlock +Z(5) /1 CP
	Move AlignBlock /1 CP
	On 8
	Wait PressureTime
	Move AlignBlock +Z(20) /1 CP
Fend

Function Place_Tray_Block
	'Tray Block
	Print "Placing Block in Tray. Block Position ID = ", Blocks
	Move TrayBlock +X(Blocks * TrayDistance) +Z(30) /1 CP
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
	Move InfeedToken +Z(Tokens * TokenHeight + InfeedHeight) /1 CP
	Move InfeedToken +Z(Tokens * TokenHeight) /1 CP
	On 8
	Wait PressureTime
	'Move InfeedToken +Z(1 + (Tokens * TokenHeight)) /1
	Move InfeedToken +X(-3) +Z(Tokens * TokenHeight + InfeedHeight) /1 CP
	
Fend

Function Alignment_Token
	'Alignment Block
	Print "Aligning Token. Token ID = ", Tokens
    Move AlignToken +Z(50) /1 CP
	Move AlignToken /1
	Off 8
	Move AlignToken +X(5) /1 CP
	Move AlignToken +X(5) +Z(5) /1 CP
	Move AlignToken +Z(5) /1 CP
	Move AlignToken /1 CP
	On 8
	Wait PressureTime
	Move AlignToken +Z(20) /1 CP
Fend

Function Place_Tray_Token
	'Tray Block
	Print "Placing Token in Tray. Token Position ID = ", Tokens
	Move TrayToken +X(Tokens * TrayDistance) +Z(30) /1 CP
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

Function main
	init()
	Block_()
	Token_()
	
	
Fend



