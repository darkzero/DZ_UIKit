//
//  Define.swift
//  DZLib
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

// check the iOS version
public func SYSTEM_VERSION_EQUAL_TO(v: String) -> Bool {
    return (UIDevice.currentDevice().systemVersion.compare(v, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) == .OrderedSame);
}
public func SYSTEM_VERSION_GREATER_THAN(v: String) -> Bool {
    return (UIDevice.currentDevice().systemVersion.compare(v, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) == .OrderedDescending);
}
public func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v: String) -> Bool {
    return (UIDevice.currentDevice().systemVersion.compare(v, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) != .OrderedAscending);
}
public func SYSTEM_VERSION_LESS_THAN(v: String) -> Bool {
    return (UIDevice.currentDevice().systemVersion.compare(v, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) == .OrderedAscending);
}
public func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v: String) -> Bool {
    return (UIDevice.currentDevice().systemVersion.compare(v, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) != .OrderedDescending);
}

public let SCREEN_BOUNDS:CGRect            = UIScreen.mainScreen().bounds;

public func DebugLog(msg: AnyObject..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    #if DEBUG
    var str = "";
    for i in 0 ..< msg.count {
        str += String(msg[i]);
    }
    print("\(file):\(function) L:\(line)|C:\(column) \(str)");
    #endif
}
