//
//  TKCalendarMonthNamesPresenter.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCalendarPresenterBase.h"

/**
 @discussion A calendar presenter responsible for rendering TKCalendar in month names view mode.
 */
@interface TKCalendarMonthNamesPresenter : TKCalendarPresenterBase

/**
 Defines the number of columns for this view.
 */
@property (nonatomic) NSInteger columns;

/**
 Returns a UILabel responsible for displaying the month name.
 */
- (UILabel*)yearLabel;

/**
 Returns a view containing month name cells.
 */
- (UIView*)contentView;

@end
