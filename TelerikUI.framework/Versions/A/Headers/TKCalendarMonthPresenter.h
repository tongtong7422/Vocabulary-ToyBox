//
//  TKCalendarBasePresenter.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCalendarPresenterBase.h"

@class TKCalendarMonthPresenterStyle;

/**
 *@discussion A calendar presenter responsible for rendering TKCalendar in month view mode.
 */
@interface TKCalendarMonthPresenter : TKCalendarPresenterBase

/**
 Determines whether the month header (containing title and day names) should be sticky when navigating to a different month.
 */
@property (nonatomic) BOOL headerIsSticky;

/**
 Determines whether the month name should be hidden.
 */
@property (nonatomic) BOOL titleHidden;

/**
 Determines whether week numbers should be hidden.
 */
@property (nonatomic) BOOL weekNumbersHidden;

/**
 Determines whether day names should be hidden.
 */
@property (nonatomic) BOOL dayNamesHidden;

/**
 Determines whether equal week number should be used.
 If this property is set to NO, the month presenter will calculate its row count based on the displayed month.
 */
@property (nonatomic) BOOL equalWeekNumber;

/**
 Returns the presenter style. Use the style properties to customize the visual appearance of TKCalendar in month view.
 */
- (TKCalendarMonthPresenterStyle*)style;

/**
 Returns a view which contains date cells.
 */
- (UIView*)contentView;

/**
 Returns the header view which contains month name and week day names.
 */
- (UIView*)headerView;

/**
 Returns a date at specific row and column
 
 @param row The row.
 @param col The column.
 
 @return An instance of NSDate if successfull.
 */
- (NSDate*)dateForRow:(NSInteger)row col:(NSInteger)col;

/**
 *  Returns an instance of TKCalendar, the owner of this presenter class.
 */
- (TKCalendar*)owner;

@end
