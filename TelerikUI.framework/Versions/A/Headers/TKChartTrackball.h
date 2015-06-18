//
//  TKChartTrackball.h
//  TelerikUI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKChart;
@class TKChartTrackballLineAnnotation;
@class TKChartTrackballTooltipAnnotation;
@class TKChartSeries;
@class TKChartDataPoint;

/**
  The trackball snapping modes.
 */
typedef enum TKChartTrackballSnapMode {
    
    /**
     Only the closest point is selected.
     */
    TKChartTrackballSnapModeClosestPoint,
    /**
     All points within the specified range are selected.
     */
    TKChartTrackballSnapModeAllClosestPoints
    
} TKChartTrackballSnapMode;

/**
  The trackball orientation modes.
 */
typedef enum TKChartTrackballOrientation {
    
    /**
     The trackball searches for points with equal x coordinates.
    */
    TKChartTrackballOrientationHorizontal,
    
    /**
     The trackball searches for points with equal y coordinates.
     */
    TKChartTrackballOrientationVertical
    
} TKChartTrackballOrientation;


/**
 The trackball used in TKChart.
 */
@interface TKChartTrackball : NSObject

/**
 Initializes the trackball with a TKChart instance.
 @param chart The chart which owns this annotation.
 */
- (id)initWithChart:(TKChart*)chart;

/**
 Displayes the trackball by specifying a plot area coordinates.
 @param point The point where the trackball should locate.
 */
- (void)showAtPoint:(CGPoint)point;

/**
 Hides the trackball.
 */
- (void)hide;

/**
 Returns a value indicating whether the trackball is currently visible (read-only).
 */
- (BOOL)isVisible;

/**
 Returns the line annotation used to present the trackball (read-only).
 */
@property (nonatomic, strong, readonly) TKChartTrackballLineAnnotation *line;

/**
 Returns the tooltip annotation used to present the trackball (read-only).
 */
@property (nonatomic, strong, readonly) TKChartTrackballTooltipAnnotation *tooltip;

/**
 Gets or sets the trackball snap mode.
 
 @discussion The available snap modes are specified below:
 
 typedef enum {
     TKChartTrackballSnapModeClosestPoint,     // Only the closest point is selected
     TKChartTrackballSnapModeAllClosestPoints, // All points within the specified range are selected
 } TKChartTrackballSnapMode;
 
 */
@property (nonatomic, assign) TKChartTrackballSnapMode snapMode;

/**
 The trackball orientation.
 
 @discussion The available orientation modes are specified below:
 
 typedef enum {
     TKChartTrackballOrientationHorizontal, // The trackball will search for points with equal x coordinates.
     TKChartTrackballOrientationVertical,   // The trackball will search for points with equal y coordinates.
 } TKChartTrackballOrientation;
 
 */
@property (nonatomic, assign) TKChartTrackballOrientation orientation;

@end
