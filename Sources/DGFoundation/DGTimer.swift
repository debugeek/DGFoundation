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
    
    private(set) var deadline: DispatchTime?
    
    private var block: ((DGTimer) -> (Void))?
    
    private var repeats: Bool = false
    
    private var ref: AnyObject?
    
    private enum State {
        case suspended
        case resumed
        case invalidated
    }
    private var state: State = .suspended
    
    @objc public class func scheduledTimer(timeInterval interval: Double, repeats: Bool = false, queue: DispatchQueue = .main, block: @escaping ((DGTimer) -> (Void))) -> DGTimer {
        let timer = DGTimer(timeInterval: interval, repeats: repeats, queue: queue, block: block)
        timer.ref = timer
        timer.resume()
        return timer
    }
    
    public init(timeInterval interval: Double, repeats: Bool = false, queue: DispatchQueue = .main, block: @escaping ((DGTimer) -> (Void))) {
        self.block = block
        self.repeats = repeats
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        
        super.init()
        
        reschedule(block: block)
        reschedule(timeInterval: interval)
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
    
    @objc(rescheduleTimeInterval:)
    public func reschedule(timeInterval interval: Double) {
        let deadline = DispatchTime.now() + interval
        self.deadline = deadline
        
        if repeats {
            timer.schedule(deadline: deadline, repeating: interval)
        } else {
            timer.schedule(deadline: deadline)
        }
    }
    
    @objc(rescheduleBlock:)
    public func reschedule(block: @escaping ((DGTimer) -> (Void))) {
        self.block = block
        
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }

            self.block?(self)

            if !self.repeats {
                self.invalidate()
            }
        }
    }
    
}
