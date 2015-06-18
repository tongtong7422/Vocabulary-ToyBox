//
//  TKCalendarMonthPresenterStyle.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKStyleNode.h"

/**
 @discussion A month presenter's style.
 */
@interface TKCalendarMonthPresenterStyle : TKStyleNode

/**
 The spacing between rows.
 */
@property (nonatomic) CGFloat rowSpacing;

/**
 The spacing between columns.
 */
@property (nonatomic) CGFloat columnSpacing;

/**
 The presenter background color.
 */
@property (nonatomic,strong) UIColor *backgroundColor;

/**
 The title cell height.
 */
@property (nonatomic) CGFloat titleCellHeight;

/**
 The day name cell height.
 */
@property (nonatomic) CGFloat dayNameCellHeight;

/**
 The week number cell width.
 */
@property (nonatomic) CGFloat weekNumberCellWidth;

@end
