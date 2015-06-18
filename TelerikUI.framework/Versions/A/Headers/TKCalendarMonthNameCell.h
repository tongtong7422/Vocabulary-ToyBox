//
//  TKCalendarMonthNameCell.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCalendarCell.h"

@class TKCalendarDayCellStyle;

/**
 @discussion A calendar cell used to present month names.
 */
@interface TKCalendarMonthNameCell : TKCalendarCell

/**
 Attaches an owner and date to the cell.
 
 @param owner The owner, an instance of TKCalendar.
 @param date  The date for the cell.
 */
- (void)attachWithCalendar:(TKCalendar*)owner withDate:(NSDate*)date;

/**
 Returns the date for this cell.
 */
- (NSDate*)date;

@end
