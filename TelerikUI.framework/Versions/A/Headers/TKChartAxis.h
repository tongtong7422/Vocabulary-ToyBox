//
//  TKAxis.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKRange;
@class TKChartSeries;
@class TKChartAxisStyle;
@class TKStyleSheet;

/**
 @enum TKChartAxisPosition
 @discussion Defines the position of the axis relative to the chart.
 */
typedef enum TKChartAxisPosition {
    /**
     The axis should be positioned at the left side of the chart.
     */
    TKChartAxisPositionLeft,
    /**
     The axis shuld be positioned at the right side of the chart.
     */
    TKChartAxisPositionRight,
    /**
     The axis should be positioned at the top side of the chart.
     */
    TKChartAxisPositionTop,
    /**
     The axis should be positioned at the bottom side of the chart.
     */
    TKChartAxisPositionBottom,
} TKChartAxisPosition;

/**
 @enum TKChartAxisPlotMode
 @discussion Defines how data points are plotted by an axis.
 */
typedef enum TKChartAxisPlotMode
{
    /**
     Points are plotted over each tick.
     */
    TKChartAxisPlotModeOnTicks,
    /**
     Points are plotted in the middle of the range, defined between each two ticks.
     */
    TKChartAxisPlotModeBetweenTicks
} TKChartAxisPlotMode;

/**
 Represents a single axis of the chart.
 
 <img src="../docs/images/chart-axes-types003.png">
 
 @see [Working with Axis](Chart-Axes-Axes)
 
 @discussion TKChart renders its points in a coordinate system defined by its axes. To do this axes specify the minimum and maximum values that can be presented on the plot area. There are a few different types of axes that can be used with TKChart. They include: numeric, date/time and categorical. You can assign each axis to different series and you can show multiple axes in chart. Axes contain various properties to control their position, style and behavior. All chart axes subclass from TKChartAxis.
 
 - Use TKChartNumericAxis to present numeric values.
 - Use TKChartDateTimeAxis to present date/time values.
 - Use TKChartCategoryAxis to present categorical values.
 
 */
@interface TKChartAxis : NSObject

/**
 @name Styling
 */

/**
 Defines the axis style.
 */
@property (nonatomic, strong) TKChartAxisStyle *style;

/**
 Determines the position of the axis.
 
 @discussion The axis positions are defined as follows:
 
     typedef enum TKChartAxisPosition {
     TKChartAxisPositionLeft,    // The axis should be positioned at the left side of the chart.
     TKChartAxisPositionRight,   // The axis shuld be positioned at the right side of the chart.
     TKChartAxisPositionTop,     // The axis should be positioned at the top side of the chart.
     TKChartAxisPositionBottom,  // The axis should be positioned at the bottom side of the chart.
     } TKChartAxisPosition;
 
 */
@property (nonatomic, assign) TKChartAxisPosition position;


/**
 Returns YES for vertical axis and NO for horizontal ones.
 */
- (BOOL)isVertical;


/**
 Defines how data points are plotted by an axis.
 
 @discussion The axis plot modes are defined as follows:
 
     typedef enum TKChartAxisPlotMode {
     TKChartAxisPlotModeOnTicks,        // Points are plotted in the middle of the range, defined between each two ticks.
     TKChartAxisPlotModeBetweenTicks,   // Points are plotted over each tick.
     } TKChartAxisPlotMode;
 
 */
@property (nonatomic, assign, readonly) TKChartAxisPlotMode plotMode;

/**
 The axis title (in plain text).
 */
@property (nonatomic, strong) NSString *title;

/**
 The axis attributed title (if needed).
 */
@property (nonatomic, strong) NSAttributedString *attributedTitle;

/**
 Defines a text format. If the text formatter is not nil, it preserves this property.
 */
@property (nonatomic, strong) NSString* labelFormat;

/**
 Defines a text formatter that preserves the textFormat property.
 */
@property (nonatomic, strong) NSFormatter *labelFormatter;

/**
 @name Ranges
 */

/**
 The axis range.
 */
@property (nonatomic, strong) TKRange *range;

/**
 * Returns the tick count for this axis.
 */
- (NSUInteger)majorTickCount;


/**
 @name Pan & Zoom
 */

/**
 Allows panning and zooming of series by this axis.
 */
@property (nonatomic) BOOL allowZoom;

/**
 The zoom level of the axis.
 */
@property (nonatomic) double zoom;

/**
 Allows panning and zooming of series by this axis.
 */
@property (nonatomic) BOOL allowPan;

/**
 The pan level of the axis.
 */
@property (nonatomic) double pan;

/**
 @name Initialization
 */

/**
 Initializes the axis with range.
 @param range The range that represents the span of the axis.
 */
- (id)initWithRange:(TKRange*)range;

/**
 Initializes the axis with its minimum and maximum range.
 @param minimum The minimum value that specifies the start of the range.
 @param maximum The maximum value that specifies the end of the range.
 */
- (id)initWithMinimum:(id)minimum andMaximum:(id)maximum;

/**
 Initializes the axis with its minimum, maximum and position.
 @param minimum The minimum value that specifies the start of the range.
 @param maximum The maximum value that specifies the end of the range.
 @param position The position value that specifies where to place the axis (left, right, top or bottom side)
 */
- (id)initWithMinimum:(id)minimum andMaximum:(id)maximum position:(TKChartAxisPosition)position;


/**
 Returns the numeric representation of a value specific for this axis.
 @param value The value which is converted to.
 @return The numeric representation of the value.
 */
- (double)numericValue:(id)value;

@end
