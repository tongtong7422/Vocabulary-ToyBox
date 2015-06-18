//
//  TKChartBalloonAnnotationStyle.h
//  TelerikUI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKChartAnnotationStyle.h"

@class TKFill;
@class TKStroke;
@class TKShape;

/**
 The vertical alignment opitons available for a balloon annotation.
 */
typedef enum TKChartBalloonVerticalAlignment {
    /**
     The balloon should appear vertically centered to the balloon location.
     */
    TKChartBalloonVerticalAlignmentCenter  = 0,
    
    /**
     The balloon should appear at the top of the balloon location.
     */
    TKChartBalloonVerticalAlignmentTop     = 1,
    
    /**
     The balloon should appear at the bottom of the balloon location.
     */
    TKChartBalloonVerticalAlignmentBottom  = 2,
    
} TKChartBalloonVerticalAlignment;

/**
 The Horizontal alignment options available for a balloon annotation.
 */
typedef enum TKChartBalloonHorizontalAlignment {
    /**
     The balloon should appear horizontally centered to the balloon location.
     */
    TKChartBalloonHorizontalAlignmentCenter = 0,
    /**
     The balloon should appear at the left of the balloon location.
     */
    TKChartBalloonHorizontalAlignmentLeft   = 1,
    
    /**
     The balloon should appear at the right of the balloon location.
     */
    TKChartBalloonHorizontalAlignmentRight  = 2,
    
} TKChartBalloonHorizontalAlignment;

/**
 The text orientation in a balloon annotation.
 */
typedef enum TKChartTrackballTooltipTextOrientation {
    /**
     Vertical orientation.
     */
    TKChartBalloonAnnotationTextOrientationVertical,
    /**
     Horizontal orientation.
     */
    TKChartBalloonAnnotationTextOrientationHorizontal,
    
} TKChartBalloonAnnotationTextOrientation;


@interface TKChartBalloonAnnotationStyle : TKChartAnnotationStyle

/**
 The view fill.
 */
@property (nonatomic, strong) TKFill *fill;

/**
 The view stroke.
 */
@property (nonatomic, strong) TKStroke *stroke;

/**
 The content's font.
 */
@property (nonatomic, strong) UIFont *font;

/**
 The content's text color.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 The text alignment.
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**
 The text orientation.
 */
@property (nonatomic, assign) TKChartBalloonAnnotationTextOrientation textOrientation;

/**
 The text insets. Use negative values to enlarge area.
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 The view vertical alignment.
 */
@property (nonatomic, assign) TKChartBalloonVerticalAlignment verticalAlign;

/**
 The view horizontal alginment.
 */
@property (nonatomic, assign) TKChartBalloonHorizontalAlignment horizontalAlign;

/**
 The distance between the ballooon and its location.
 */
@property (nonatomic, assign) CGFloat distanceFromPoint;

/**
 The arrow size.
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 The corner radius of a balloon.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

@end
