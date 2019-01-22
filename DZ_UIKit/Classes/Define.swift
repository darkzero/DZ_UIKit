//
//  Define.swift
//  DZ_UIKit
//
//  Created by Dora.Yuan on 14/10/25.
//  Copyright (c) 2014年 Dora.Yuan All rights reserved.
//

import Foundation
import UIKit

// check the iOS version
public func SYSTEM_VERSION_EQUAL_TO(_ v: String) -> Bool {
    return (UIDevice.current.systemVersion.compare(v, options: String.CompareOptions.numeric, range: nil, locale: nil) == .orderedSame)
}
public func SYSTEM_VERSION_GREATER_THAN(_ v: String) -> Bool {
    return (UIDevice.current.systemVersion.compare(v, options: String.CompareOptions.numeric, range: nil, locale: nil) == .orderedDescending)
}
public func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(_ v: String) -> Bool {
    return (UIDevice.current.systemVersion.compare(v, options: String.CompareOptions.numeric, range: nil, locale: nil) != .orderedAscending)
}
public func SYSTEM_VERSION_LESS_THAN(_ v: String) -> Bool {
    return (UIDevice.current.systemVersion.compare(v, options: String.CompareOptions.numeric, range: nil, locale: nil) == .orderedAscending)
}
public func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(_ v: String) -> Bool {
    return (UIDevice.current.systemVersion.compare(v, options: String.CompareOptions.numeric, range: nil, locale: nil) != .orderedDescending)
}

public let SCREEN_BOUNDS = { return UIScreen.main.bounds }

public func DebugLog(_ msg: Any..., file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
#if DEBUG
    var str = ""
    for i in 0 ..< msg.count {
        str += String(describing: msg[i])
    }
    print("\((file as NSString).lastPathComponent) [L:\(line)|C:\(column)] - \(function) :\(str)")
#endif
}
