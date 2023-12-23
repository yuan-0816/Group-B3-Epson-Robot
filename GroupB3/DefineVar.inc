#define Height 6.0
#define TrayDistance 30.0
#define InfeedHeight 20.0
#define PressureTime 0.1

#define RED 0
#define ORANGE 1
#define GREEN 2
#define BLUE 3
#define WHITE 4


Global Integer Tokens, Blocks, TokenID, BlockID, Jengas

' 放料
Global Double ToTrayBlock_X, ToTrayBlock_Y, ToTrayBlock_Z
Global Double ToTrayToken_X, ToTrayToken_Y, ToTrayToken_Z

' 取料
Global Double ToInfeedBlock_X, ToInfeedBlock_Y, ToInfeedBlock_Z
Global Double ToInfeedToken_X, ToInfeedToken_Y, ToInfeedToken_Z


' 對齊
Global Double ToAlignBlock_X, ToAlignBlock_Y, ToAlignBlock_Z
Global Double ToAlignToken_X, ToAlignToken_Y, ToAlignToken_Z

' 疊疊樂
Global Double ToJengas_X, ToJengas_Y, ToJengas_Z

Global Boolean IsSim
Global Boolean IsPick
