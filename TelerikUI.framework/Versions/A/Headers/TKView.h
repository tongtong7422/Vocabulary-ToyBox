//
//  TKView.h
//  TelerikUI
//
//  Copyright (c) 2013 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKFill;
@class TKStroke;
@protocol TKLayout;

/**
 UIView subclass which provides custom fill, stroke and layout information
 */
@interface TKView : UIView

/**
 The view's fill
 */
@property (nonatomic, strong) TKFill *fill;

/**
 The view's stroke
 */
@property (nonatomic, strong) TKStroke *stroke;

/**
 The view's layout
 */
@property (nonatomic, strong) id<TKLayout> layout;

@end
