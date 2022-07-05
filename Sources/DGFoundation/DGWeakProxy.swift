//
//  DGWeakProxy.swift
//  DGFoundation
//
//  Created by Xiao Jin on 2022/6/3.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation

open class DGWeakProxy: NSObject {

    @objc public weak var target: NSObject?

    @objc public convenience init(target: NSObject) {
        self.init()
        self.target = target
    }

    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }

    open override func isProxy() -> Bool {
        return true
    }

}

extension DGWeakProxy {

    open override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) ?? false
    }

    open override var hash: Int {
        return target?.hash ?? -1
    }

    open override var superclass: AnyClass? {
        return target?.superclass ?? nil
    }

    open override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) ?? false
    }

    open override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) ?? false
    }

    open override func conforms(to aProtocol: Protocol) -> Bool {
        return  target?.conforms(to: aProtocol) ?? false
    }

    open override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }

    open override var description: String {
        return target?.description ?? "nil"
    }

    open override var debugDescription: String {
        return target?.debugDescription ?? "nil"
    }

}

