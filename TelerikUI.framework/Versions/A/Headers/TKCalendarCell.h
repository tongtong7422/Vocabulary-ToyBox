//
//  TKCalMonthCell.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCalendarCellStyle;
@class TKCalendar;

/**
 *  @discussion Represents a base class for cells used in TKCalendar.
 */
@interface TKCalendarCell : UIView

/**
 *  A label used to display the cell text.
 */
@property (nonatomic, strong, readonly) UILabel *label;

/**
 *  An instance of TKCalendar, the owner of this object.
 */
- (TKCalendar*)owner;

/**
 *  Returns the cell style. Use the style property to customize the visual appearance of TKCalendarCell.
 */
- (TKCalendarCellStyle*)style;

/**
 *  Updates the visual appearance of the cell based on its content.
 */
- (void)updateVisuals;

@end
