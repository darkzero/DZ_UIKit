//
//  DateUtil.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 2014/10/08.
//  Copyright (c) 2014 Dora.Yuan All rights reserved.
//

import Foundation

open class DateUtil {
    
    public class func StringFromDate( date:Date? , formatString:String? ) -> String {
        guard let _date = date, let _format = formatString else {
            return "N/A";
        }
        let formatter           = DateFormatter();
        formatter.dateFormat    = _format;
        formatter.timeZone      = TimeZone(identifier: "...");
        let dateString          = formatter.string(from: _date);
        return dateString;
    }
    
    public class func dateFromString(DateString dateString:String, FormatString formatString:String) -> Date {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat        = formatString;
        let theDate:Date?           = formatter.date(from: dateString);
        return theDate!;
    }
    
    public class func adjustZeroClock(_ date: Date, withCalendar calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: date);
        return calendar.date(from: components)!;
    }
    
    public class func daysBetween(startDate: Date?, endDate: Date?) -> Int {
        guard let _start = startDate, let _end = endDate else {
            return 0;
        }
        let calendar    = Calendar(identifier: .gregorian);
        let _startDate  = DateUtil.adjustZeroClock(_start, withCalendar: calendar);
        let _endDate    = DateUtil.adjustZeroClock(_end, withCalendar: calendar);
    
        let components = calendar.dateComponents([.day], from: _startDate, to: _endDate);
        let days = components.day;
        return days!;
    }
}
