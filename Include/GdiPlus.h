&& GdiPlus error flags
#DEFINE GDIP_OK                                             0
#DEFINE GDIP_GENERIC_ERROR                                  1
#DEFINE GDIP_INVALID_PARAMETER                              2
#DEFINE GDIP_OUT_OF_MEMORY                                  3
#DEFINE GDIP_OBJECT_BUSY                                    4
#DEFINE GDIP_INSUFFICIENT_BUFFER                            5
#DEFINE GDIP_NOT_IMPLEMENTED                                6
#DEFINE GDIP_WIN32_ERROR                                    7
#DEFINE GDIP_WRONG_STATE                                    8
#DEFINE GDIP_ABORTED                                        9
#DEFINE GDIP_FILE_NOT_FOUND                                10
#DEFINE GDIP_VALUE_OVERFLOW                                11
#DEFINE GDIP_ACCESS_DENIED                                 12
#DEFINE GDIP_UNKNOWN_IMAGE_FORMAT                          13
#DEFINE GDIP_FONT_FAMILY_NOT_FOUND                         14
#DEFINE GDIP_FONT_STYLE_NOT_FOUND                          15
#DEFINE GDIP_NOT_TRUE_TYPE_FONT                            16
#DEFINE GDIP_UNSUPPORTED_GDIPLUS_VERSION                   17
#DEFINE GDIP_GDIPLUS_NOT_INITIALIZED                       18
#DEFINE GDIP_PROPERTY_NOT_FOUND                            19
#DEFINE GDIP_PROPERTY_NOT_SUPPORTED                        20

&& Additional error flags
#DEFINE GDIP_VFP_INVALID_PARAMETER                         -1   && The passed parameters are incorrect.
#DEFINE GDIP_VFP_FILE_NOT_FOUND                            -2   && The specified file or window doesn't exist.
#DEFINE GDIP_VFP_CANNOT_CREATE_STREAM                      -3   && Cannot create stream.
#DEFINE GDIP_VFP_CLIPBOARD_OPERATIONS_FAILURE              -4   && Clipboard operation has been failed.
#DEFINE GDIP_VFP_GRAPHICHS_CANNOT_CREATE                   -5   && Cannot create Graphics object
#DEFINE GDIP_VFP_BITMAP_DOESNT_EXIST                       -6   && A bitmap with the specified key doesn't exist in the bitmaps collection.
#DEFINE GDIP_VFP_BITMAP_ALREADY_EXISTS                     -7   && A bitmap with the specified key already exists in the bitmaps collection.
#DEFINE GDIP_VFP_IMAGEATTRIBUTES_ALREADY_EXISTS            -8   && An ImageAttributes object with the specified key already exists in the ImageAttributes collection.        
#DEFINE GDIP_VFP_PEN_DOESNT_EXIST                          -9   && A pen with the specified key doesn't exist in the pens collection.
#DEFINE GDIP_VFP_PEN_ALREADY_EXISTS                        -10  && A pen with the specified key already exists in the pens collection.
#DEFINE GDIP_VFP_PATH_DOESNT_EXIST                         -11  && A path with the specified key doesn't exist in the paths collection.
#DEFINE GDIP_VFP_PATH_ALREADY_EXISTS                       -12  && A path with the specified key already exists in the paths collection.
#DEFINE GDIP_VFP_BRUSH_DOESNT_EXIST                        -13  && A brush with the specified key doesn't exist in the brushes collection.
#DEFINE GDIP_VFP_BRUSH_ALREADY_EXISTS                      -14  && A brush with the specified key already exists in the brushes collection.
#DEFINE GDIP_VFP_FONT_ALREADY_EXISTS                       -15  && A font with the specified key already exists in the fonts collection.
#DEFINE GDIP_VFP_REGION_DOESNT_EXIST                       -16  && A region with the specified key doesn't exist in the regions collection.
#DEFINE GDIP_VFP_REGION_ALREADY_EXISTS                     -17  && A region with the specified key already exists in the region collection.
#DEFINE GDIP_VFP_POINT_IS_OUTSIDE_REGION                   -18  && A point with the specified coordinates is outside the specified region.
#DEFINE GDIP_VFP_API_EXECUTION_FAILURE                     -19  && API function execution has been failed.

&& Color Matrix flags
#DEFINE GDIP_ColorMatrixFlagsDefault                        0
#DEFINE GDIP_ColorMatrixFlagsSkipGrays                      1
#DEFINE GDIP_ColorMatrixFlagsAltGray                        2

&& GdiPlus Rotate and Flip codes
#DEFINE GDIPLUS_ROTATEFLIPTYPE_RotateNoneFlipNone           0  
#DEFINE GDIPLUS_ROTATEFLIPTYPE_Rotate90FlipNone             1
#DEFINE GDIPLUS_ROTATEFLIPTYPE_Rotate180FlipNone            2
#DEFINE GDIPLUS_ROTATEFLIPTYPE_Rotate270FlipNone            3
#DEFINE GDIPLUS_ROTATEFLIPTYPE_RotateNoneFlipX              4
#DEFINE GDIPLUS_ROTATEFLIPTYPE_Rotate90FlipX                5
#DEFINE GDIPLUS_ROTATEFLIPTYPE_Rotate180FlipX               6
#DEFINE GDIPLUS_ROTATEFLIPTYPE_Rotate270FlipX               7

&& GdiPlus Font Styles
#DEFINE GDIPLUS_FontStyle_Regular                           0
#DEFINE GDIPLUS_FontStyle_Bold                              1
#DEFINE GDIPLUS_FontStyle_Italic                            2
#DEFINE GDIPLUS_FontStyle_BoldItalic                        3
#DEFINE GDIPLUS_FontStyle_Underline                         4
#DEFINE GDIPLUS_FontStyle_Strikeout                         8

&& GdiPlus image formats
#DEFINE GDIPLUS_IMAGEFORMAT_MemoryBMP                      0hAA3C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_BMP                            0hAB3C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_EMF                            0hAC3C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_WMF                            0hAD3C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_JPEG                           0hAE3C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_PNG                            0hAF3C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_GIF                            0hB03C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_TIFF                           0hB13C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_EXIF                           0hB23C6BB92807D3119D7B0000F81EF32E
#DEFINE GDIPLUS_IMAGEFORMAT_ICON                           0hB53C6BB92807D3119D7B0000F81EF32E

&& GdiPlus image formats descriptions
#DEFINE GDIPLUS_IMAGEFORMATDESCR_MemoryBMP                 "MemoryBMP"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_BMP                       "BMP"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_EMF                       "EMF"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_WMF                       "WMF"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_JPEG                      "JPEG"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_PNG                       "PNG"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_GIF                       "GIF"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_TIFF                      "TIFF"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_EXIF                      "EXIF"
#DEFINE GDIPLUS_IMAGEFORMATDESCR_ICON                      "Icon"

&& Auxiliary constants - picture formats
#DEFINE GDIPLUS_PICTUREFORMAT_BMP                          "BMP"
#DEFINE GDIPLUS_PICTUREFORMAT_JPG                          "JPG"
#DEFINE GDIPLUS_PICTUREFORMAT_GIF                          "GIF"
#DEFINE GDIPLUS_PICTUREFORMAT_TIF                          "TIF"
#DEFINE GDIPLUS_PICTUREFORMAT_PNG                          "PNG"

&& Pixel formats
#DEFINE GDIPLUS_PIXELFORMAT_Undefined                      0
#DEFINE GDIPLUS_PIXELFORMAT_1bppIndexed                    0x00030101
#DEFINE GDIPLUS_PIXELFORMAT_4bppIndexed                    0x00030402
#DEFINE GDIPLUS_PIXELFORMAT_8bppIndexed                    0x00030803
#DEFINE GDIPLUS_PIXELFORMAT_16bppGrayScale                 0x00101004
#DEFINE GDIPLUS_PIXELFORMAT_16bppRGB555                    0x00021005
#DEFINE GDIPLUS_PIXELFORMAT_16bppRGB565                    0x00021006
#DEFINE GDIPLUS_PIXELFORMAT_16bppARGB1555                  0x00061007
#DEFINE GDIPLUS_PIXELFORMAT_24bppRGB                       0x00021808
#DEFINE GDIPLUS_PIXELFORMAT_32bppRGB                       0x00022009
#DEFINE GDIPLUS_PIXELFORMAT_32bppARGB                      0x0026200A
#DEFINE GDIPLUS_PIXELFORMAT_32bppPARGB                     0x000E200B
#DEFINE GDIPLUS_PIXELFORMAT_48bppRGB                       0x0010300C
#DEFINE GDIPLUS_PIXELFORMAT_64bppPARGB                     0x001C400E

&& Pixel format descriptions
#DEFINE GDIPLUS_PIXELFORMATDESCR_Undefined                  "Undefined"
#DEFINE GDIPLUS_PIXELFORMATDESCR_1bppIndexed                "1bppIndexed"
#DEFINE GDIPLUS_PIXELFORMATDESCR_4bppIndexed                "4bppIndexed"
#DEFINE GDIPLUS_PIXELFORMATDESCR_8bppIndexed                "8bppIndexed"
#DEFINE GDIPLUS_PIXELFORMATDESCR_16bppGrayScale             "16bppGrayScale"
#DEFINE GDIPLUS_PIXELFORMATDESCR_16bppRGB555                "16bppRGB555"
#DEFINE GDIPLUS_PIXELFORMATDESCR_16bppRGB565                "16bppRGB565"
#DEFINE GDIPLUS_PIXELFORMATDESCR_16bppARGB1555              "16bppARGB1555"
#DEFINE GDIPLUS_PIXELFORMATDESCR_24bppRGB                   "24bppRGB"
#DEFINE GDIPLUS_PIXELFORMATDESCR_32bppRGB                   "32bppRGB"
#DEFINE GDIPLUS_PIXELFORMATDESCR_32bppARGB                  "32bppARGB"
#DEFINE GDIPLUS_PIXELFORMATDESCR_32bppPARGB                 "32bppPARGB"
#DEFINE GDIPLUS_PIXELFORMATDESCR_48bppRGB                   "48bppRGB"
#DEFINE GDIPLUS_PIXELFORMATDESCR_64bppPARGB                 "64bppPARGB"

&& Palette flags
#DEFINE GDIPLUS_PaletteFlagsHasAlpha                        0x0001
#DEFINE GDIPLUS_PaletteFlagsGrayScale                       0x0002
#DEFINE GDIPLUS_PaletteFlagsHalftone                        0x0004


&& Angled corner types
#DEFINE GDIPLUS_ANGLEDCORNER_RIGHT                         1  && Right angle
#DEFINE GDIPLUS_ANGLEDCORNER_RIGHT_RAISED                  2  && Raised right angle
#DEFINE GDIPLUS_ANGLEDCORNER_RIGHT_SUNKEN                  3  && Sunken right angle
#DEFINE GDIPLUS_ANGLEDCORNER_ROUNDED_RAISED                4  && Rounded raised corner
#DEFINE GDIPLUS_ANGLEDCORNER_ROUNDED_RAISED_EXT_1          5  && Rounded extra raised corner, variant 1
#DEFINE GDIPLUS_ANGLEDCORNER_ROUNDED_RAISED_EXT_2          6  && Rounded extra raised corner, variant 2
#DEFINE GDIPLUS_ANGLEDCORNER_ROUNDED_SUNKEN                7  && Rounded sunken corner
#DEFINE GDIPLUS_ANGLEDCORNER_ROUNDED_SUNKEN_EXT_1          8  && Rounded extra sunken corner, variant 1
#DEFINE GDIPLUS_ANGLEDCORNER_ROUNDED_SUNKEN_EXT_2          9  && Rounded extra sunken corner, variant 2
#DEFINE GDIPLUS_ANGLEDCORNER_STRAIGHT                      10 && Straight line
#DEFINE GDIPLUS_ANGLEDCORNER_STRAIGHT_RAISED               11 && Straight raised line
#DEFINE GDIPLUS_ANGLEDCORNER_STRAIGHT_SUNKEN               12 && Straight sunken line

&& Gdiplus Units
#DEFINE GDIPLUS_UnitWorld                                  0
#DEFINE GDIPLUS_UnitDisplay                                1
#DEFINE GDIPLUS_UnitPixel                                  2
#DEFINE GDIPLUS_UnitPoint                                  3
#DEFINE GDIPLUS_UnitInch                                   4
#DEFINE GDIPLUS_UnitDocument                               5
#DEFINE GDIPLUS_UnitMillimeter                             6

&& Gdiplus QualityModes
#DEFINE GDIPLUS_QualityMode_Invalid                       -1
#DEFINE GDIPLUS_QualityMode_Default                        0
#DEFINE GDIPLUS_QualityMode_Low                            1  && Best performance
#DEFINE GDIPLUS_QualityMode_High                           2  && Best rendering quality

&& Gdiplus Interpolation Modes
#DEFINE GDIPLUS_InterpolationMode_Invalid                  GDIPLUS_QualityMode_Invalid    && Equivalent to the Invalid element of the QualityMode enumeration. For internal use only.
#DEFINE GDIPLUS_InterpolationMode_Default                  GDIPLUS_QualityMode_Default    && Specifies default mode.
#DEFINE GDIPLUS_InterpolationMode_LowQuality               GDIPLUS_QualityMode_Low        && Specifies low quality interpolation.
#DEFINE GDIPLUS_InterpolationMode_HighQuality              GDIPLUS_QualityMode_High       && Specifies high quality interpolation.
#DEFINE GDIPLUS_InterpolationMode_Bilinear                 3                              && Specifies bilinear interpolation. No prefiltering is done. This mode is not suitable for shrinking an image below 50 percent of its original size.
#DEFINE GDIPLUS_InterpolationMode_Bicubic                  4                              && Specifies bicubic interpolation. No prefiltering is done. This mode is not suitable for shrinking an image below 25 percent of its original size.
#DEFINE GDIPLUS_InterpolationMode_NearestNeighbor          5                              && Specifies nearest-neighbor interpolation. 
#DEFINE GDIPLUS_InterpolationMode_HighQualityBilinear      6                              && Specifies high-quality, bilinear interpolation. Prefiltering is performed to ensure high-quality shrinking.
#DEFINE GDIPLUS_InterpolationMode_HighQualityBicubic       7                              && Specifies high-quality, bicubic interpolation. Prefiltering is performed to ensure high-quality shrinking. This mode produces the highest quality transformed images.

&& Smoothing Mode
#DEFINE GDIPLUS_SmoothingMode_Invalid                      GDIPLUS_QualityMode_Invalid
#DEFINE GDIPLUS_SmoothingMode_Default                      GDIPLUS_QualityMode_Default
#DEFINE GDIPLUS_SmoothingMode_HighSpeed                    GDIPLUS_QualityMode_Low
#DEFINE GDIPLUS_SmoothingMode_HighQuality                  GDIPLUS_QualityMode_High
#DEFINE GDIPLUS_SmoothingMode_None                         3
#DEFINE GDIPLUS_SmoothingMode_AntiAlias                    4

&& Pen Styles
#DEFINE GDIPLUS_DashStyleSolid                             0
#DEFINE GDIPLUS_DashStyleDash                              1
#DEFINE GDIPLUS_DashStyleDot                               2
#DEFINE GDIPLUS_DashStyleDashDot                           3
#DEFINE GDIPLUS_DashStyleDashDotDot                        4
#DEFINE GDIPLUS_DashStyleCustom                            5

&& Pen line caps
#DEFINE GDIPLUS_LineCapFlat                                0
#DEFINE GDIPLUS_LineCapSquare                              1
#DEFINE GDIPLUS_LineCapRound                               2
#DEFINE GDIPLUS_LineCapTriangle                            3
#DEFINE GDIPLUS_LineCapNoAnchor                            0x10
#DEFINE GDIPLUS_LineCapSquareAnchor                        0x11
#DEFINE GDIPLUS_LineCapRoundAnchor                         0x12
#DEFINE GDIPLUS_LineCapDiamondAnchor                       0x13
#DEFINE GDIPLUS_LineCapArrowAnchor                         0x14
#DEFINE GDIPLUS_LineCapCustom                              0xff

&& Fill mode (how a closed path is filled)
#DEFINE GDIPLUS_FillMode_Alternate                         0
#DEFINE GDIPLUS_FillMode_Winding                           1

&& Hatch Brush styles
#DEFINE GDIPLUS_HatchStyle_Horizontal                      0
#DEFINE GDIPLUS_HatchStyle_Vertical                        1
#DEFINE GDIPLUS_HatchStyle_ForwardDiagonal                 2
#DEFINE GDIPLUS_HatchStyle_BackwardDiagonal                3
#DEFINE GDIPLUS_HatchStyle_Cross                           4
#DEFINE GDIPLUS_HatchStyle_DiagonalCross                   5
#DEFINE GDIPLUS_HatchStyle_05Percent                       6
#DEFINE GDIPLUS_HatchStyle_10Percent                       7
#DEFINE GDIPLUS_HatchStyle_20Percent                       8
#DEFINE GDIPLUS_HatchStyle_25Percent                       9
#DEFINE GDIPLUS_HatchStyle_30Percent                       10
#DEFINE GDIPLUS_HatchStyle_40Percent                       11
#DEFINE GDIPLUS_HatchStyle_50Percent                       12
#DEFINE GDIPLUS_HatchStyle_60Percent                       13
#DEFINE GDIPLUS_HatchStyle_70Percent                       14
#DEFINE GDIPLUS_HatchStyle_75Percent                       15
#DEFINE GDIPLUS_HatchStyle_80Percent                       16
#DEFINE GDIPLUS_HatchStyle_90Percent                       17
#DEFINE GDIPLUS_HatchStyle_LightDownwardDiagonal           18
#DEFINE GDIPLUS_HatchStyle_LightUpwardDiagonal             19
#DEFINE GDIPLUS_HatchStyle_DarkDownwardDiagonal            20
#DEFINE GDIPLUS_HatchStyle_DarkUpwardDiagonal              21
#DEFINE GDIPLUS_HatchStyle_WideDownwardDiagonal            22
#DEFINE GDIPLUS_HatchStyle_WideUpwardDiagonal              23
#DEFINE GDIPLUS_HatchStyle_LightVertical                   24
#DEFINE GDIPLUS_HatchStyle_LightHorizontal                 25
#DEFINE GDIPLUS_HatchStyle_NarrowVertical                  26
#DEFINE GDIPLUS_HatchStyle_NarrowHorizontal                27
#DEFINE GDIPLUS_HatchStyle_DarkVertical                    28
#DEFINE GDIPLUS_HatchStyle_DarkHorizontal                  29
#DEFINE GDIPLUS_HatchStyle_DashedDownwardDiagonal          30
#DEFINE GDIPLUS_HatchStyle_DashedUpwardDiagonal            31
#DEFINE GDIPLUS_HatchStyle_DashedHorizontal                32
#DEFINE GDIPLUS_HatchStyle_DashedVertical                  33
#DEFINE GDIPLUS_HatchStyle_SmallConfetti                   34
#DEFINE GDIPLUS_HatchStyle_LargeConfetti                   35
#DEFINE GDIPLUS_HatchStyle_ZigZag                          36
#DEFINE GDIPLUS_HatchStyle_Wave                            37
#DEFINE GDIPLUS_HatchStyle_DiagonalBrick                   38
#DEFINE GDIPLUS_HatchStyle_HorizontalBrick                 39
#DEFINE GDIPLUS_HatchStyle_Weave                           40
#DEFINE GDIPLUS_HatchStyle_Plaid                           41
#DEFINE GDIPLUS_HatchStyle_Divot                           42
#DEFINE GDIPLUS_HatchStyle_DottedGrid                      43
#DEFINE GDIPLUS_HatchStyle_DottedDiamond                   44
#DEFINE GDIPLUS_HatchStyle_Shingle                         45
#DEFINE GDIPLUS_HatchStyle_Trellis                         46
#DEFINE GDIPLUS_HatchStyle_Sphere                          47
#DEFINE GDIPLUS_HatchStyle_SmallGrid                       48
#DEFINE GDIPLUS_HatchStyle_SmallCheckerBoard               49
#DEFINE GDIPLUS_HatchStyle_LargeCheckerBoard               50
#DEFINE GDIPLUS_HatchStyle_OutlinedDiamond                 51
#DEFINE GDIPLUS_HatchStyle_SolidDiamond                    52

&& Wrap mode for brushes
#DEFINE GDIPLUS_WrapMode_Tile                              0
#DEFINE GDIPLUS_WrapMode_TileFlipX                         1
#DEFINE GDIPLUS_WrapMode_TileFlipY                         2
#DEFINE GDIPLUS_WrapMode_TileFlipXY                        3
#DEFINE GDIPLUS_WrapMode_Clamp                             4

&& Linear Gradient Mode
#DEFINE GDIPLUS_LinearGradientMode_Horizontal              0
#DEFINE GDIPLUS_LinearGradientMode_Vertical                1
#DEFINE GDIPLUS_LinearGradientMode_ForwardDiagonal         2
#DEFINE GDIPLUS_LinearGradientMode_BackwardDiagonal        3

&& Text Rendering Hints
#DEFINE GDIPLUS_TextRenderingHintSystemDefault             0
#DEFINE GDIPLUS_TextRenderingHintSingleBitPerPixelGridFit  1
#DEFINE GDIPLUS_TextRenderingHintSingleBitPerPixel         2
#DEFINE GDIPLUS_TextRenderingHintAntiAliasGridFit          3
#DEFINE GDIPLUS_TextRenderingHintAntiAlias                 4
#DEFINE GDIPLUS_TextRenderingHintClearTypeGridFit          5

&& Regions Combine Mode
#DEFINE GDIPLUS_CombineMode_Replace                        0
#DEFINE GDIPLUS_CombineMode_Intersect                      1
#DEFINE GDIPLUS_CombineMode_Union                          2
#DEFINE GDIPLUS_CombineMode_Xor                            3
#DEFINE GDIPLUS_CombineMode_Exclude                        4
#DEFINE GDIPLUS_CombineMode_Complement                     5

&& Color Adjustment Types
#DEFINE GDIPLUS_ColorAdjustTypeDefault                     0
#DEFINE GDIPLUS_ColorAdjustTypeBitmap                      1
#DEFINE GDIPLUS_ColorAdjustTypeBrush                       2
#DEFINE GDIPLUS_ColorAdjustTypePen                         3
#DEFINE GDIPLUS_ColorAdjustTypeText                        4
#DEFINE GDIPLUS_ColorAdjustTypeCount                       5
#DEFINE GDIPLUS_ColorAdjustTypeAny                         6

&& LockBits flags
#DEFINE GDIPLUS_ImageLockModeRead                          0x0001
#DEFINE GDIPLUS_ImageLockModeWrite                         0x0002
#DEFINE GDIPLUS_ImageLockModeUserInputBuf                  0x0004

&& PixelOffsetMode
#DEFINE GDIPLUS_PixelOffsetModeInvalid                     GDIPLUS_QualityMode_Invalid
#DEFINE GDIPLUS_PixelOffsetModeDefault                     GDIPLUS_QualityMode_Default
#DEFINE GDIPLUS_PixelOffsetModeHighSpeed                   GDIPLUS_QualityMode_Low
#DEFINE GDIPLUS_PixelOffsetModeHighQuality                 GDIPLUS_QualityMode_High
#DEFINE GDIPLUS_PixelOffsetModeNone                        GDIPLUS_QualityMode_High + 1
#DEFINE GDIPLUS_PixelOffsetModeHalf                        GDIPLUS_QualityMode_High + 2

&& GdiPlus other constants
#DEFINE GDIPLUS_ENCODER_Quality                             0hB5E45B1D4AFA2D459CDD5DB35105E7EB

&& Common WinAPI constants
#DEFINE CF_BITMAP                                           2 
#DEFINE CF_PALETTE                                          9
#DEFINE GW_CHILD                                            5
#DEFINE GWL_WNDPROC                                        -4
#DEFINE WM_PAINT                                            0x000F
#DEFINE WM_ERASEBKGND                                       0x0014
#DEFINE SRCCOPY                                             0x00CC0020 
#DEFINE FLOODFILLBORDER                                     0
#DEFINE FLOODFILLSURFACE                                    1

&& Unsupported GdiPlus effects GUIDs
#DEFINE GDIPLUS_BlurEffectGuid                              0h633C80A41843482B9EF2BE2834C5FDD4
#DEFINE GDIPLUS_SharpenEffectGuid                           0h63CBF3EEC526402C8F7162C540BF5142
#DEFINE GDIPLUS_ColorMatrixEffectGuid                       0h718F2615793340E3A5115F68FE14DD74
#DEFINE GDIPLUS_ColorLutEffectGuid                          0hA7CE72A90F7F40D7B3CCD0C02D5C3212
#DEFINE GDIPLUS_BrightnessContrastEffectGuid                0hD3A1DBE18EC44C179F4CEA97AD1C343D
#DEFINE GDIPLUS_HueSaturationLightnessEffectGuid            0h8B2DD6C3EB074D87A5F07108E26A9C5F
#DEFINE GDIPLUS_LevelsEffectGuid                            0h99C354EC2A314F3A8C3417A803B33A25
#DEFINE GDIPLUS_TintEffectGuid                              0h1077AF0028484441948944AD4C2D7A2C
#DEFINE GDIPLUS_ColorBalanceEffectGuid                      0h537E597D251E48DA966429CA496B70F8
#DEFINE GDIPLUS_RedEyeCorrectionEffectGuid                  0h74D29D0569A4426695493CC52836B632
#DEFINE GDIPLUS_ColorCurveEffectGuid                        0hDD6A002258E44A679D9BD48EB881A53D

*#DEFINE GDIPLUS_BlurEffectGuid                     0x633C80A4,0x1843,0x482b,0x09E,0x0F2,0x0BE,0x028,0x034,0x0C5,0x0FD,0x0D4
*#DEFINE GDIPLUS_SharpenEffectGuid                  0x63CBF3EE,0xC526,0x402C,0x08F,0x071,0x062,0x0C5,0x040,0x0BF,0x051,0x042
*#DEFINE GDIPLUS_ColorMatrixEffectGuid              0x718F2615,0x7933,0x40E3,0x0A5,0x011,0x05F,0x068,0x0FE,0x014,0x0DD,0x074
*#DEFINE GDIPLUS_ColorLutEffectGuid                 0xA7CE72A9,0x0F7F,0x40D7,0x0B3,0x0CC,0x0D0,0x0C0,0x02D,0x05C,0x032,0x012
*#DEFINE GDIPLUS_BrightnessContrastEffectGuid       0xD3A1DBE1,0x8EC4,0x4C17,0x09F,0x04C,0x0EA,0x097,0x0AD,0x01C,0x034,0x03D
*#DEFINE GDIPLUS_HueSaturationLightnessEffectGuid   0x8B2DD6C3,0xEB07,0x4D87,0x0A5,0x0F0,0x071,0x008,0x0E2,0x06A,0x09C,0x05F
*#DEFINE GDIPLUS_LevelsEffectGuid                   0x99C354EC,0x2A31,0x4F3A,0x08C,0x034,0x017,0x0A8,0x003,0x0B3,0x03A,0x025
*#DEFINE GDIPLUS_TintEffectGuid                     0x1077AF00,0x2848,0x4441,0x094,0x089,0x044,0x0AD,0x04C,0x02D,0x07A,0x02C
*#DEFINE GDIPLUS_ColorBalanceEffectGuid             0x537E597D,0x251E,0x48DA,0x096,0x064,0x029,0x0CA,0x049,0x06B,0x070,0x0F8
*#DEFINE GDIPLUS_RedEyeCorrectionEffectGuid         0x74D29D05,0x69A4,0x4266,0x095,0x049,0x03C,0x0C5,0x028,0x036,0x0B6,0x032
*#DEFINE GDIPLUS_ColorCurveEffectGuid               0xDD6A0022,0x58E4,0x4A67,0x09D,0x09B,0x0D4,0x08E,0x0B8,0x081,0x0A5,0x03D