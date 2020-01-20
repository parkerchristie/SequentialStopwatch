//
//  Stopwatch.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2019-05-21.
//  Copyright © 2019 Parker Christie. All rights reserved.
//

import Foundation

class Stopwatch {
    public private(set) var length: Double
    private var timeRemaining: Double
    private var isRunning: Bool
    private var isPaused: Bool
    private let timeIncrement = 0.1
    
    init(stopwatchLength: Double) {
        self.length = stopwatchLength
        self.timeRemaining = stopwatchLength
        self.isRunning = false;
        self.isPaused = false;
    }
    
    public func startStopwatch() {
        isRunning = true
        timeRemaining = length - timeIncrement
    }
    
    public func updateStopwatch() {
        if isRunning && !isPaused {
            self.timeRemaining -= timeIncrement
        }
    }
    
    public func endStopwatch() {
        isRunning = false
    }
    
    public func pauseStopwatch() {
        isPaused = true
    }
    
    public func resumeStopwatch() {
        if isPaused {
            isPaused = false
        }
    }
    
    public func stopStopwatch() {
        if isRunning {
            isRunning = false
            timeRemaining = length
        }
    }
    
    public func getTimeRemaining() -> Double {
        return self.timeRemaining
    }
    
    public func getCurrentState() -> Bool {
        return isRunning
    }
    
}
