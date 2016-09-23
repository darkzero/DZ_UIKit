//
//  NSDate+FormatedString.swift
//  DZLib
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation

open class DateUtil {
    
    open class func StringFromDate(Date date:Date, formatString:String) -> String
    {
        let formatter:DateFormatter   = DateFormatter();
        formatter.dateFormat            = formatString;
        formatter.timeZone              = TimeZone(identifier: "...");
        let dateString                  = formatter.string(from: date);
        
        return dateString;
    }
    
    open class func dateFromString(DateString dateString:String, FormatString formatString:String) -> Date
    {
        let formatter:DateFormatter   = DateFormatter();
        formatter.dateFormat            = formatString;
        let theDate:Date?             = formatter.date(from: dateString);
        return theDate!;
    }
    
    open class func adjustZeroClock(_ date: Date, withCalendar calendar: Calendar) -> Date
    {
        let components = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date);
        return calendar.date(from: components)!;
    }
    
    open class func daysBetween(startDate: Date, endDate: Date?) -> Int
    {
        if endDate == nil {
            return 0;
        }
        let calendar    = Calendar(identifier: Calendar.Identifier.gregorian);
        let _startDate  = DateUtil.adjustZeroClock(startDate, withCalendar: calendar);
        let _endDate    = DateUtil.adjustZeroClock(endDate!, withCalendar: calendar);
    
        let components = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: _startDate, to: _endDate, options: NSCalendar.Options());
        let days = components.day;
        return days!;
    }
}
