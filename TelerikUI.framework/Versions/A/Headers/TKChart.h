//
//  TKChart.h
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKView.h"

@class TKChart;
@class TKChartAxis;
@class TKChartGridStyle;
@class TKChartLegendView;
@class TKChartPaletteItem;
@class TKChartSelectionInfo;
@class TKChartSeries;
@class TKChartSeriesRenderState;
@class TKChartStyle;
@class TKChartTitleView;
@class TKMutableArray;
@class TKShape;
@class TKTheme;
@class TKChartVisualPoint;
@class TKChartAnnotation;
@class TKChartTrackball;

@protocol TKChartData;
@protocol TKChartDataSource;
@protocol TKChartDelegate;

typedef enum TKChartSelectionMode
{
    TKChartSelectionModeSingle,
    TKChartSelectionModeMultiple
} TKChartSelectionMode;

/**
 TKChart is a versatile charting component that offers great performance, drawing capabilities and intuitive object model. Thanks to the public API you can set up complex charts with stunning animations and appearance easily through code. TKChart supports various series types: bar, column, line, spline, area, pie, donut and scatter. These series can also be stacked where appropriate. Among its supported features are pan/zoom funcionality, multiple axes and animations that use CoreAnimations and UIKit dynamics.
  <img src="../docs/images/chart-overview001.png">
 
 @see [TKChart Overview](chart-overview)
 @see [Managing the data source](chart-populatingwithdata)
 @see [Custom Animations](chart-animations-custom)
 @see [Custom Animations with UIKit Dynamics](chart-animations-customuikitdynamics)
 @see [TKChart selection](chart-selection)
 @see [Customizing TKChart data appearance](chart-customdrawing)
 @see [Customization of data point appereance](chart-series-pointcustomization)
 */
@interface TKChart : TKView

/**
 Returns the version of the chart
 */
+ (NSString*)versionString;

/**
 @name Accessing Views and Styling
 */

/**
 Returns TKChart legend view.
 */
- (TKChartLegendView*)legend;

/**
 Returns TKChart title view.
 */
- (TKChartTitleView*)title;

/**
 Returns TKChart plot view.
 */
- (UIView*)plotView;

/**
 Returns TKChart style.
 */
- (TKChartGridStyle *)gridStyle;

/**
 TKChart content insets relative to its view size.
*/
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 @return TKChart theme.
 */
@property (nonatomic, strong) TKTheme* theme;

/**
 Returns a value indicating whether the user can select single or multiple series/data points.
 */
@property (nonatomic, assign) TKChartSelectionMode selectionMode;



/**
 @name Configuring TKChart Animations
 */

/**
 Determines whether TKChart allows animations.
 */
@property (nonatomic) BOOL allowAnimations;

/**
 Determines the animation duration. This value is used by default animations in TKChart.
 */
@property (nonatomic) CFTimeInterval animationDuration;

/**
 Causes the chart to animate its content. The allowAnimations property should be set to true before calling this method.
 You can customise TKChart animations by handling the chart:animationForSeries:withState:inRect: method of TKChartDelegate.
 */
- (void)animate;





/**
 @name Managing the Delegate and the Data Source
 */

/**
 A delegate for styling the chart and receiving notifications.
 */
@property (nonatomic, weak) id<TKChartDelegate> delegate;

/**
 Sets data-source delegate.
 @return The data-source delegate.
 */
@property (nonatomic, assign) id<TKChartDataSource> dataSource;


/**
 @name Configuring Axes
 */

/**
 TKChart main x-axis.
 */
@property (nonatomic, strong) TKChartAxis *xAxis;

/**
 TKChart y-Axis.
 */
@property (nonatomic, strong) TKChartAxis *yAxis;

/**
 An array that contains the axes of the chart.
 @return All axes of the chart.
 */
- (NSArray*)axes;

/**
 Adds an axis to the chart.
 @param axis The axis that should be added to the chart.
 */
- (void)addAxis:(TKChartAxis*)axis;

/**
 Removes an axis from the chart.
 @param axis The axis that should be removed from the chart.
 */
- (BOOL)removeAxis:(TKChartAxis*)axis;





/**
 @name Configuring Series
 */

/**
 A read-only array of the TKChartSeries objecs displayed on the chart.
 */
- (NSArray*)series;

/** 
 Adds a series to the chart.
 @param series The series that should be added to the chart.
 */
- (void)addSeries:(TKChartSeries *)series;

/**
 Returns a reusable chart-view series object located by its identifier.
 @param identifier The string identifying the cell object to be reused. This parameter must not be nil.
 */
- (id)dequeueReusableSeriesWithIdentifier:(NSString *)identifier;

/** 
 Removes the specified series from the chart.
 @param series The series that should be removed from the chart.
 */
- (void)removeSeries:(TKChartSeries*)series;

/**
 Returns the chart's crosshair
 */
@property (nonatomic, strong, readonly) TKChartTrackball *trackball;

/**
 Determines whether TKChart allows the trackball behavior.
 */
@property (nonatomic, assign) BOOL allowTrackball;

/**
 @name Configuring Annotations
 */

/**
 Returns the chart annotations
 */
- (NSArray*)annotations;

/**
 Adds annotation to the chart
 @param annotation The annotation that will be added.
 */
- (void)addAnnotation:(TKChartAnnotation *)annotation;

/**
 Removes annotation from the chart
 @param annotation The annotation that will be removed.
 */
- (void)removeAnnotation:(TKChartAnnotation*)annotation;

/**
 Removes all annotations from the chart
 */
- (void)removeAllAnnotations;

/**
 Forces annotations to update
 */
- (void)updateAnnotations;

/**
 @name Data manipulation
 */

/**
 Reloads the data-source and rebuilds the UI. Call this method to reload all the data that is used to construct the chart.
 */
- (void)reloadData;

/**
 Removes all series & axes from the chart.
 */
- (void)removeAllData;

/**
 Begins a series of method calls that insert, delete, or select dataPoints and series of the receiver.
 */
- (void)beginUpdates;

/**
 Concludes a series of method calls that insert, delete, select, or reload dataPoints and series of the receiver.
 */
- (void)endUpdates;



/**
 @name Managing Selections
 */

/**
 Returns the data point located at specified coordinates.
 @param point The point to be used for hit testing.
 */
- (TKChartSelectionInfo *)hitTestForPoint:(CGPoint)point;

/**
 Selects a series and its data point.
 @param info The selection information object.
 */
- (void)select:(TKChartSelectionInfo*)info;

/**
 Returns an array containing the visual point elements for a given series.
 Visual points can be modified only when animations are allowed.
 The animate method should be called to reflect all changes made in visual points.
 @param series The series that contains the requested points.
 */
- (NSArray*)visualPointsForSeries:(TKChartSeries*)series;

/**
 Returns a visual point element at a specific point index and series.
 Visual points can be modified only when animations are allowed.
 The animate method should be called to reflect all changes made in visual points.
 @param series The series that contains the requested point.
 @param dataPointIndex The point index of the requested point.
 */
- (TKChartVisualPoint*)visualPointForSeries:(TKChartSeries*)series dataPointIndex:(NSInteger)dataPointIndex;

@end // TKChart



/**
 @discussion The TKChartDataSource protocol is adopted by an object that mediates the application's data model for a TKChart object.
 The data source provides the chart-view object with the information it needs to construct and modify a chart view.
 */
@protocol TKChartDataSource <NSObject>

@required
/**
 Asks the data-source to return the number of series in the chart.
 @param chart An object representing the chart requesting this information.
 */
- (NSUInteger)numberOfSeriesForChart:(TKChart *)chart;

/**
 Asks the data-source to return a series for the chart at a particular index.
 @param index The index of the series.
 @param chart The TKChart instance requesting this information.
 */
- (TKChartSeries *)seriesForChart:(TKChart *)chart atIndex:(NSUInteger)index;

@optional

/**
 Asks the data-source to return the number of data point in series for the chart.
 @param seriesIndex The index of series.
 @param chart The object representing the chart requesting this information.
 */
- (NSUInteger)chart:(TKChart *)chart numberOfDataPointsForSeriesAtIndex:(NSUInteger)seriesIndex;

/**
 Asks the data-source to return a data point from a specified series.
 @param seriesIndex The index of the series.
 @param dataIndex The index of data point.
 @param chart The TKChart instance requesting this information.
 */
- (id<TKChartData>)chart:(TKChart *)chart dataPointAtIndex:(NSUInteger)dataIndex forSeriesAtIndex:(NSUInteger)seriesIndex;

/**
 Asks the data-source to return an array of data points from a specified series.
 @param seriesIndex The series index.
 @param chart The TKChart instance requesting this information.
 */
- (NSArray *)chart:(TKChart *)chart dataPointsForSeriesAtIndex:(NSUInteger)seriesIndex;

@end // TKChartDataSource



/**
 @discussion The methods declared by the TKChartDelegate protocol allow the adopting delegate to respond to messages from the TKChart class and thus respond to, and in some affect, operations such as panning, zooming and data animations.
 */
@protocol TKChartDelegate <NSObject>

@optional


/**
 @name Changing TKChart appearance
 */

/**
 Returns an instance of TKChartPaletteItem based on the specified series and index.
 @param chart The TKChart instance requesting this information.
 @param series The series of the palette item that is being requested.
 @param index The item index for the series.
 @return The instance of TKChartPaletteItem that contains style settings for specific series.
 */
- (TKChartPaletteItem *)chart:(TKChart *)chart paletteItemForSeries:(TKChartSeries *)series atIndex:(NSUInteger)index;

/**
 Returns a shape for a specified series and index.
 @param chart The TKChart instance requesting the shape.
 @param series The series of the palette item that is being requested.
 @param index The index of the series item.
 @return An instance of TKChartPaletteItem that contains style settings for a specific series.
 */
- (TKShape *)chart:(TKChart *)chart shapeForSeries:(TKChartSeries *)series atIndex:(NSUInteger)index;

/**
 Creates an animation for particular series.
 @param chart The TKChart instance requesting this information.
 @param series The series to which the animation will be applied.
 @param state The series' visual state.
 @param rect The viewport of the plot area.
 */
- (CAAnimation*)chart:(TKChart*)chart animationForSeries:(TKChartSeries*)series withState:(TKChartSeriesRenderState*)state inRect:(CGRect)rect;



/**
 @name Handling TKChart notifications
 */

/**
 Called on selecting series and/or data point.
 @param chart The TKChart for which the selection has occurred.
 @param series The series on which the user tapped. Can be nil in case of deselecting.
 @param dataPoint The nearest data point at which the user tapped. It might be nil.
 @param dataIndex The index of the nearest data point at which user tapped. It might be -1 in case of missing dataIndex information.
 */
- (void)chart:(TKChart *)chart selectedSeries:(TKChartSeries *)series dataPoint:(id<TKChartData>)dataPoint dataIndex:(NSInteger)dataIndex;



/**
 Tells the delegate when the chart view is about to start zooming the content.
 @param chart The TKChart instance displaying the content.
 */
- (void)chartWillZoom:(TKChart*)chart;

/**
 Tells the delegate that the TKChart zoom factor changed.
 @param chart The TKChart instance displaying the content.
 */
- (void)chartDidZoom:(TKChart*)chart;

/**
 *
 Tells the delegate when the TKChart is about to start panning the content.
 @param chart The TKChart instance displaying the content.
 */
- (void)chartWillPan:(TKChart*)chart;

/**
 Tells the delegate that the TKChart pan factor changed.
 @param chart The TKChart instance displaying the content.
 */
- (void)chartDidPan:(TKChart*)chart;

/**
 Called on trackball moved
 @param chart The TKChart for which the crosshair moved
 @param selection The array of TKChartSelectionInfo
 */
- (void)chart:(TKChart *)chart trackballDidTrackSelection:(NSArray*)selection;

@end // TKChartDelegate
