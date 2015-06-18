//
//  TKChartDataPoint.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKChartData.h"

/**
 @discussion The basic implementation of the TKChartData protocol.
 */
@interface TKChartDataPoint : NSObject<TKChartData>

/**
 Creates a data point.
 @param xValue X axis value.
 @param yValue Y axis value.
 */
+ (instancetype)dataPointWithX:(id)xValue Y:(id)yValue;

/**
 Creates a data point.
 @param xValue X axis value.
 @param yValue Y axis value.
 @param name The data point name (used in Pie/Donut Charts).
 */
+ (instancetype)dataPointWithX:(id)xValue Y:(id)yValue name:(NSString *)name;

/**
 Creates a data point.
 @param xValue X axis value.
 @param yValue Y axis value.
 */
- (id)initWithX:(id)xValue Y:(id)yValue;

/**
 Creates a data point.
 @param xValue X axis value.
 @param yValue Y axis value.
 @param name The data point name (used in Pie/Donut Charts).
 */
- (id)initWithX:(id)xValue Y:(id)yValue name:(NSString *)name;

/**
 Creates a data point.
 @param value The point value. By default, this sets the xvalue.
 @param name The data point name (used in Pie/Donut Charts).
 */
- (id)initWithValue:(id)value name:(NSString *)name;

/**
 X axis value.
*/
@property (nonatomic, strong, readwrite) id dataXValue;

/**
 Y axis value.
 */
@property (nonatomic, strong, readwrite) id dataYValue;

/**
 The name of the value (used in Pie/Donut Charts).
 */
@property (nonatomic, strong, readwrite) NSString* dataName;

@end
