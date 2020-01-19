//
//  StopwatchManager.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2019-05-22.
//  Copyright © 2019 Parker Christie. All rights reserved.
//

import Foundation

class StopwatchManager {
    
    var isRunning = Bool()
    var isPaused = Bool()
    var stopwatchList = [Stopwatch?]()
    var currentStopwatch: Stopwatch?
    var timer: Timer?
    
    weak var delegate: StopwatchManagerListener?
    
    init() {
        isRunning = false
    }
    
    public func addStopwatch(length: Int) {
        let newStopwatch = Stopwatch(stopwatchLength: length)
        stopwatchList.append(newStopwatch)
    }
    
    public func startStopwatches() {
        if stopwatchList.count < 1 {
            return
        }
        else {
            isRunning = true
            isPaused = false
            currentStopwatch = stopwatchList[0]
            currentStopwatch?.startStopwatch()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStopwatches), userInfo: nil, repeats: true)
            delegate?.onStart()
            delegate?.onNextStopwatch()
        }
    }
    
    @objc private func updateStopwatches() {
        currentStopwatch?.updateStopwatch()
        if (((currentStopwatch?.getTimeRemaining())!) < 0) {
            nextStopwatch()
        }
        delegate?.onUpdate()
    }
    
    public func nextStopwatch() {
        currentStopwatch?.endStopwatch()
        delegate?.onStopwatchFinish()
        let stopwatchIndex: Int?
        stopwatchIndex = stopwatchList.firstIndex(where: { $0 === currentStopwatch})
        if (stopwatchIndex! + 1 < stopwatchList.count) {
            currentStopwatch = stopwatchList[stopwatchIndex! + 1]
            currentStopwatch?.startStopwatch()
            delegate?.onNextStopwatch()
        }
        else {
            endStopwatches()
        }
    }
    
    public func endStopwatches() {
        currentStopwatch?.endStopwatch()
        delegate?.onStopwatchFinish()
        currentStopwatch = nil
        timer?.invalidate()
        isRunning = false
        isPaused = false
        delegate?.onStop()
    }
    
    public func removeStopwatch(stopwatch: Stopwatch) {
        let stopwatchIndex: Int?
        stopwatchIndex = stopwatchList.firstIndex(where: { $0 === stopwatch})
        
        if stopwatchIndex != nil {
            stopwatchList.remove(at: stopwatchIndex!)
            stopwatchList = stopwatchList.filter { $0 != nil }
        }
    }
    
    public func removeStopwatch(index: Int) {
        stopwatchList.remove(at: index)
        stopwatchList = stopwatchList.filter {
            $0 != nil
        }
    }
    
    public func pauseStopwatches() {
        isPaused = true
        currentStopwatch?.pauseStopwatch()
        timer?.invalidate()
        delegate?.onPause()
    }
    
    public func resumeStopwatches() {
        if stopwatchList.count < 1 && !isPaused {
            return
        }
        isPaused = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStopwatches), userInfo: nil, repeats: true)
        currentStopwatch?.resumeStopwatch()
        delegate?.onResume()
    }
    
    public func getNextStopwatchLength() -> Int? {
        let stopwatchIndex: Int?
        
        if currentStopwatch == nil {
            if stopwatchList.count == 0 {
                return nil
            }
            else {
                return stopwatchList[0]?.length
            }
        }
        
        stopwatchIndex = stopwatchList.firstIndex(where: { $0 === currentStopwatch})
        if (stopwatchIndex! + 1 < stopwatchList.count) {
            return stopwatchList[stopwatchIndex! + 1]?.length
        }
        return nil
    }
    
    // Returns the length of the stopwatch after the given index
    public func getNextStopwatchLength(index: Int) -> Int? {
        if stopwatchList.count < index + 2 {
            return nil
        }
        
        return stopwatchList[index + 1]?.length
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
