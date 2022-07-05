//
//  DGWeakReference.swift
//  DGFoundation
//
//  Created by Xiao Jin on 2022/6/29.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation

open class DGWeakReference: NSObject {

    @objc public weak var target: AnyObject?
    
    @objc public convenience init(target: AnyObject) {
        self.init()
        self.target = target
    }

}
