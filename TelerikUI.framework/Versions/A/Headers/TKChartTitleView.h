//
//  TKChartTitleView.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKChartTitleStyle;

/**
 @enum TKChartTitlePosition
 @discussion The possible positions of TKChart title.
 */
typedef enum TKChartTitlePosition
{
    /**
     The chart title should be positioned at the left side of the chart.
     */
    TKChartTitlePositionLeft,
    
    /**
     The chart title should be positioned at the right side of the chart.
     */
    TKChartTitlePositionRight,
    
    /** 
     The chart title should be positioned at the top side of the chart.
     */
    TKChartTitlePositionTop,

    /**
     The chart title should be positioned at the bottom side of the chart.
     */
    TKChartTitlePositionBottom
    
} TKChartTitlePosition;

@interface TKChartTitleView : UILabel

/** 
 The position of the TKChart title.

 @discussion The axis title alignments are defined as follows:
 
    typedef enum {
        TKChartTitlePositionLeft,       // The chart title should be positioned at the left side of the chart.
        TKChartTitlePositionRight,      // The chart title should be positioned at the right side of the chart.
        TKChartTitlePositionTop,        // The chart title should be positioned at the top side of the chart.
        TKChartTitlePositionBottom      // The chart title should be positioned at the bottom side of the chart.
    } TKChartTitlePosition;

 */
@property TKChartTitlePosition position;

/**
 The title's view style.
 */
@property (nonatomic, strong) TKChartTitleStyle *style;


@end
