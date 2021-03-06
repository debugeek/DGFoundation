//
//  DGTimer.swift
//  DGFoundation
//
//  Created by Xiao Jin on 2022/6/13.
//  Copyright © 2022 debugeek. All rights reserved.
//

import Foundation

open class DGTimer: NSObject {

    private let timer: DispatchSourceTimer
    
    private var block: ((DGTimer) -> (Void))?
    
    private var repeats: Bool = false
    
    private var ref: AnyObject?
    
    private enum State {
        case suspended
        case resumed
        case invalidated
    }
    private var state: State = .suspended
    
    @objc public class func scheduledTimer(timeInterval interval: Double, repeats: Bool, queue: DispatchQueue, block: @escaping ((DGTimer) -> (Void))) -> DGTimer {
        let timer = DGTimer(timeInterval: interval, repeats: repeats, queue: queue, block: block)
        timer.ref = timer
        timer.resume()
        return timer
    }
    
    public init(timeInterval interval: Double, repeats: Bool, leeway: DispatchTimeInterval = .nanoseconds(0), queue: DispatchQueue = .main, block: @escaping ((DGTimer) -> (Void))) {
        self.block = block
        self.repeats = repeats
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        
        super.init()
        
        timer.setEventHandler { [weak self] in
            if let self = self {
                self.block?(self)
            }
        }

        if repeats {
            timer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            timer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }
    
    deinit {
        if state != .invalidated {
            invalidate()
        }
    }
    
    @objc public func resume() {
        guard state == .suspended else {
            return
        }
        timer.resume()
        state = .resumed
    }
    
    @objc public func suspend() {
        guard state == .resumed else {
            return
        }
        timer.suspend()
        state = .suspended
    }
    
    @objc public func invalidate() {
        ref = nil
        block = nil
        timer.setEventHandler(handler: nil)
        if state == .suspended {
            timer.resume()
        }
        timer.cancel()
        state = .invalidated
    }
    
    @objc(rescheduleRepeatingInterval:)
    public func reschedule(repeatingInterval interval: Double) {
        guard repeats else {
            return
        }
        timer.schedule(deadline: .now() + interval, repeating: interval)
    }
    
    @objc(rescheduleBlock:)
    public func reschedule(block: @escaping ((DGTimer) -> (Void))) {
        self.block = block
        timer.setEventHandler { [weak self] in
            if let self = self {
                self.block?(self)
            }
        }

    }
    
}
