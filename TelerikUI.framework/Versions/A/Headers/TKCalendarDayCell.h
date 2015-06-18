//
//  TKCalendarDayCell.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCalendarCell.h"

@class TKCalendarDayCellStyle;

/**
 * @enum TKCalendarDayState
 * @discussion Represents an enum that defines the date cell state.
 */
typedef enum TKCalendarDayState {
    
    /**
     *  The date is today.
     */
    TKCalendarDayStateToday            = 1 << 0,
    
    /**
     *  The date represents a weekend.
     */
    TKCalendarDayStateWeekend          = 1 << 1,
    
    /**
     *  The date is contained within the currently presented month.
     */
    TKCalendarDayStateCurrentMonth     = 1 << 2,
    
    /**
     *  The date is contained within the currently presented year.
     */
    TKCalendarDayStateCurrentYear      = 1 << 3,
    
    /**
     *  The date is selected.
     */
    TKCalendarDayStateSelected         = 1 << 4,
    
    /**
     *  The date is the first date in a range selection.
     */
    TKCalendarDayStateFirstInSelection = 1 << 5,
    
    /**
     *  The date is the last date in a range selection.
     */
    TKCalendarDayStateLastInSelection  = 1 << 6,
    
    /**
     *  The date is a mid date in a range selection.
     */
    TKCalendarDayStateMidInSelection   = 1 << 7,
    
} TKCalendarDayState;

/**
 *  @discussion A calendar cell used to present dates in TKCalendar.
 */
@interface TKCalendarDayCell : TKCalendarCell

/**
 *  The cell state.
 *  @discussion The available cell states are specified below:
 
 typedef enum TKCalendarDayState {
 TKCalendarDayStateToday            // The date is today
 TKCalendarDayStateWeekend          // The date represents a weekend.
 TKCalendarDayStateCurrentMonth     // The date is contained within the currently presented month.
 TKCalendarDayStateCurrentYear      // The date is contained within the currently presented year.
 TKCalendarDayStateSelected         // The date is selected.
 TKCalendarDayStateFirstInSelection // The date is the first date in a range selection.
 TKCalendarDayStateLastInSelection  // The date is the last date in a range selection.
 TKCalendarDayStateMidInSelection   // The date is a mid date in a range selection.
 } TKCalendarDayState

 */
@property (nonatomic) TKCalendarDayState state;

/**
 *  Attaches a date and owner to the cell.
 *
 *  @param owner The owner for this cell, an instance of TKCalendar.
 *  @param date  The date that will be presented by this cell.
 */
- (void)attachWithCalendar:(TKCalendar*)owner withDate:(NSDate*)date;

/**
 *  Returns the cell style. Use the style property to customize the visual appearance of TKCalendarCell.
 */
- (TKCalendarDayCellStyle*)style;

/**
 *  Returns the date represented by this cell.
 */
- (NSDate*)date;

/**
 *  Returns an array containing all events for this cell.
 */
- (NSArray*)events;

@end
