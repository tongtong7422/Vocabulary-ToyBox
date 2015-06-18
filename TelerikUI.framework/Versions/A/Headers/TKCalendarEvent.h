//
//  TKCalendarEvent.h
//  Telerik UI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @discussion Represents an event used in TKCalendar class.
 */
@interface TKCalendarEvent : NSObject

/**
 The start time for the event.
 */
@property (nonatomic, strong) NSDate *startDate;

/**
 The end time for the event.
 */
@property (nonatomic, strong) NSDate *endDate;

/**
 The event title.
 */
@property (nonatomic, strong) NSString *title;

/**
 The event location.
 */
@property (nonatomic, strong) NSString *location;

/**
 The event description.
 */
@property (nonatomic, strong) NSString *description;

/**
 Indicates whether the event is an all day event or not.
 */
@property (nonatomic, getter = isAllDay) BOOL allDay;

/**
 Defines the event color.
 */
@property (nonatomic, strong) UIColor *eventColor;

@end
