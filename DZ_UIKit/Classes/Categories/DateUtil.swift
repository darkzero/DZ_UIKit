//
//  DateUtil.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation

open class DateUtil {
    
    public class func StringFromDate(Date date:Date, formatString:String) -> String
    {
        let formatter           = DateFormatter();
        formatter.dateFormat    = formatString;
        formatter.timeZone      = TimeZone(identifier: "...");
        let dateString          = formatter.string(from: date);
        return dateString;
    }
    
    public class func dateFromString(DateString dateString:String, FormatString formatString:String) -> Date
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat        = formatString;
        let theDate:Date?           = formatter.date(from: dateString);
        return theDate!;
    }
    
    public class func adjustZeroClock(_ date: Date, withCalendar calendar: Calendar) -> Date
    {
        let components = calendar.dateComponents([.year, .month, .day], from: date);
        return calendar.date(from: components)!;
    }
    
    public class func daysBetween(startDate: Date, endDate: Date?) -> Int
    {
        if endDate == nil {
            return 0;
        }
        let calendar    = Calendar(identifier: .gregorian);
        let _startDate  = DateUtil.adjustZeroClock(startDate, withCalendar: calendar);
        let _endDate    = DateUtil.adjustZeroClock(endDate!, withCalendar: calendar);
    
        let components = calendar.dateComponents([.day], from: _startDate, to: _endDate);
        let days = components.day;
        return days!;
    }
}
