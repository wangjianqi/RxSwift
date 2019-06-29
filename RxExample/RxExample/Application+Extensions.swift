//
//  Application+Extensions.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 8/20/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias OSApplication = UIApplication
#elseif os(macOS)
    import Cocoa
    typealias OSApplication = NSApplication
#endif

extension OSApplication {
    ///是否测试
    static var isInUITest: Bool {
        return ProcessInfo.processInfo.environment["isUITest"] != nil;
    }
}
