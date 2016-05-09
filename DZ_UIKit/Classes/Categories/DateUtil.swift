//
//  NSDate+FormatedString.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation

public class DateUtil {
    
    public class func StringFromDate(Date date:NSDate, formatString:String) -> String
    {
        let formatter:NSDateFormatter   = NSDateFormatter();
        formatter.dateFormat            = formatString;
        formatter.timeZone              = NSTimeZone(name: "...");
        let dateString                  = formatter.stringFromDate(date);
        
        return dateString;
    }
    
    public class func dateFromString(DateString dateString:String, FormatString formatString:String) -> NSDate
    {
        let formatter:NSDateFormatter   = NSDateFormatter();
        formatter.dateFormat            = formatString;
        let theDate:NSDate?             = formatter.dateFromString(dateString);
        return theDate!;
    }
    
    public class func adjustZeroClock(date: NSDate, withCalendar calendar: NSCalendar) -> NSDate
    {
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date);
        return calendar.dateFromComponents(components)!;
    }
    
    public class func daysBetween(startDate startDate: NSDate, endDate: NSDate?) -> Int
    {
        if endDate == nil {
            return 0;
        }
        let calendar    = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!;
        let _startDate  = DateUtil.adjustZeroClock(startDate, withCalendar: calendar);
        let _endDate    = DateUtil.adjustZeroClock(endDate!, withCalendar: calendar);
    
        let components = calendar.components(NSCalendarUnit.Day, fromDate: _startDate, toDate: _endDate, options: NSCalendarOptions());
        let days = components.day;
        return days;
    }
}