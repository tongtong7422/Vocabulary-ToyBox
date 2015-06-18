//
//  TKChartSeriesStyle.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKStyleNode.h"

typedef enum TKChartSeriesStylePaletteMode {
    /**
     Uses series index when asking for theme palette color.
    */
    TKChartSeriesStylePaletteModeUseSeriesIndex,
    /**
     Uses item index when asking for theme palette color.
     */
    TKChartSeriesStylePaletteModeUseItemIndex
} TKChartSeriesStylePaletteMode;

typedef enum TKChartSeriesStyleShapeMode {
    /**
     Does not show shapes on the first and the last point of the area and line series (default).
     */
    TKChartSeriesStyleShapeModeShowOnMiddlePointsOnly,
    /**
     Shows all shapes.
     */
    TKChartSeriesStyleShapeModeAlwaysShow,
} TKChartSeriesStyleShapeMode;

@class TKChartPalette;
@class TKFill;
@class TKStroke;
@class TKChartPaletteItem;
@class TKShape;

@interface TKChartSeriesStyle : TKStyleNode

/**
 The palette containing item colors.
 */
@property (nonatomic, strong) TKChartPalette *palette;

/**
 Specifies how you ask for colors in the palette.
 
 @discussion When the palette mode is TKChartSeriesStylePaletteModeUseSeriesIndex, the series index is used
 as a color index in the palette and the item index is ignored.
 
 When the palette mode is TKChartSeriesStylePaletteModeUseItemIndex, the item index is used
 as ca olor index in the palette.
 
 The palette modes are defined as follows:
 
    typedef enum {
        TKChartSeriesStylePaletteModeUseSeriesIndex, // Uses series index when asking for theme palette color.
        TKChartSeriesStylePaletteModeUseItemIndex    // Uses item index when asking for theme palette color.
    } TKChartSeriesStylePaletteMode;

*/
@property (nonatomic, assign) TKChartSeriesStylePaletteMode paletteMode;

/**
 Shape to draw at the data points. It is supported for line, area and scatter series.
 By default, it is a circle with a size of 6 px on scatter series and nil (no shape) for line and area.
*/
@property (nonatomic, strong) TKShape *pointShape;

/**
 For line and area series this property determines the shapes that are shown for first and last points.
 
 @discussion The shape modes are defined as follows:

    typedef enum {
        TKChartSeriesStyleShapeModeShowOnMiddlePointsOnly,  // Does not show shapes on the first and the last point of the area and line series (default).
        TKChartSeriesStyleShapeModeAlwaysShow,              // Shows all shapes.
    } TKChartSeriesStyleShapeMode;

 */
@property (nonatomic, assign) TKChartSeriesStyleShapeMode shapeMode;

/**
 The palette containing the shape colors used.
 */
@property (nonatomic, strong) TKChartPalette *shapePalette;

/**
 The fill color to be used.
 @return An instance of UIColor representing the fill color.
 */
@property (nonatomic, strong) TKFill *fill;

/**
 The stroke color to be used.
 @return An instance of UIColor representing the stroke color.
 */
@property (nonatomic, strong) TKStroke *stroke;

@end
