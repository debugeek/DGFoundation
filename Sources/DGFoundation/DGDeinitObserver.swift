//
//  DGDeinitObserver.swift
//  DGFoundation
//
//  Created by Xiao Jin on 2022/7/10.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation

open class DGDeinitObserver: NSObject {

    private let callback: () -> Void
    
    static var observerKey: UInt8 = 0
    
    @objc(observeObject:callback:)
    public class func observe(object: AnyObject, callback: @escaping () -> Void) {
        let observer = DGDeinitObserver(callback: callback)
        objc_setAssociatedObject(object, &Self.observerKey, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private init(callback: @escaping () -> Void) {
        self.callback = callback
        super.init()
    }
    
    deinit {
        callback()
    }
    
}
