//
//  DateHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/24/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import Foundation

public class DateHelper {
  
  /* return an array of dates in consecutive days before the given date */
  public class func getDatesInPastDays (date: NSDate, days: Int = 7) -> [NSDate] {
    var calendar = NSCalendar.currentCalendar()
    var components = NSDateComponents()
//    calendar.da
//    var components = calendar.componentsInTimeZone(calendar.timeZone, fromDate: date)
//    println(components)
//    let day = components.day
//    
    var dates = [NSDate]()
//    for dayOffset in 0..days {
//      components.day = day - dayOffset
//      dates.append(calendar.dateFromComponents(components))
//    }
    
    for dayOffset in 0..<days {
      components.day = -dayOffset
      dates.append(calendar.dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!)
//      dates.append(calendar.dateByAddingUnit(.CalendarUnitDay, value: -dayOffset, toDate: date, options: nil))
    }
    
    return dates.reverse()
    
  }
  
  public class func getDaysInWeek (date: NSDate) -> [NSDate] {
    var calendar = NSCalendar.currentCalendar()
    var components = NSDateComponents()
    
    var days = [NSDate]()
    var beginningOfWeek: NSDate?
    
//    var ok = calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &beginningOfWeek, interval: nil, forDate: date)
    var ok = calendar.rangeOfUnit(NSCalendarUnit.NSWeekCalendarUnit, startDate: &beginningOfWeek, interval: nil, forDate: date)
    for offset in 0..<7 {
      components.day = offset
      days.append(calendar.dateByAddingComponents(components, toDate: beginningOfWeek!, options:  NSCalendarOptions(rawValue: 0))!)
    }
    
    return days
  }
  
  /* return the boundary of that day (12am in the morning, 12am at night) */
  public class func getDayBoundary (date: NSDate) -> (NSDate, NSDate) {
    var calendar = NSCalendar.currentCalendar()

//    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
    var components = calendar.components([NSCalendarUnit.NSYearCalendarUnit , NSCalendarUnit.NSMonthCalendarUnit , NSCalendarUnit.NSDayCalendarUnit], fromDate: date)
    var dateFrom = calendar.dateFromComponents(components)
    components.day += 1
    var dateTo = calendar.dateFromComponents(components)
    
    return (dateFrom!, dateTo!)
  }
  
  public class func getSomeDaysEarlier (date: NSDate, days: Int = 2) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
//    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
    var components = calendar.components([NSCalendarUnit.NSYearCalendarUnit , NSCalendarUnit.NSMonthCalendarUnit , NSCalendarUnit.NSDayCalendarUnit], fromDate: date)
    components.day -= days
    return calendar.dateFromComponents(components)!
  }
  
  
  /* return the boundary of the week (12am last Monday, 12am next Monday) */
//  class func getWeekBoundary (date: NSDate) -> (NSDate, NSDate) {
//    var calendar = NSCalendar.currentCalendar()
//    var components = calendar.components(NSCalendarUnit., fromDate: date)
//  }
  
}