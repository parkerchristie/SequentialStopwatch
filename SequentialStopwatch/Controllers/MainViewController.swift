//
//  ViewController.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2019-05-21.
//  Copyright © 2019 Parker Christie. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class MainViewController: UIViewController, StopwatchManagerListener {
    
    var stopwatchManager = StopwatchManager()
    
    @IBOutlet private weak var countdownTimer: UILabel!
    
    @IBOutlet private weak var nextStopwatchLabel: UILabel!
    
    @IBOutlet private weak var nextStopwatchLengthLabel: UILabel!
    
    @IBOutlet private weak var triggerStopwatchButton: UIButton!
    
    @IBOutlet private weak var stopStopwatchButton: UIButton!
    
    @IBOutlet private weak var editStopwatchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopwatchManager.delegate = self
        resetCountdownLabel()
        updateNextStopwatchLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetCountdownLabel()
        updateNextStopwatchLabel()
    }
    
    @IBAction private func triggerStopwatches(sender: UIButton) {
        if !stopwatchManager.isRunning {
            stopwatchManager.startStopwatches()
        }
        else if !stopwatchManager.isPaused {
            stopwatchManager.pauseStopwatches()
        }
        else {
            stopwatchManager.resumeStopwatches()
        }
    }
    
    private func resetCountdownLabel() {
        if #available(iOS 13.0, *) {
            if !stopwatchManager.isRunning {
                var nextStopwatchLength : Double?
                nextStopwatchLength = stopwatchManager.getNextStopwatchLength()
                
                if nextStopwatchLength != nil {
                    let (h, m, s) = stopwatchManager.secondsToHoursMinutesSeconds(seconds: nextStopwatchLength!)
                    countdownTimer.text = String(format:"%02d:%02d:%02d", h, m, s)
                }
                triggerStopwatchButton.setImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
                stopStopwatchButton.isEnabled = false
                editStopwatchButton.isEnabled = true
                
            }
        }
    }
    
    @IBAction private func stopStopwatches(_ sender: UIButton) {
        stopwatchManager.endStopwatches()
    }
    
    @objc private func updateRunningStopwatchLabel() {
        let timeRemaining = stopwatchManager.currentStopwatch?.getTimeRemaining()
        if (timeRemaining != nil) {
            let (h, m, s) = stopwatchManager.secondsToHoursMinutesSeconds(seconds: timeRemaining!)
            countdownTimer.text = String(format:"%02d:%02d:%02d", h, m, s)
        }
    }
    
    func onStart() {
        updateRunningStopwatchLabel()
        stopStopwatchButton.isEnabled = true
        editStopwatchButton.isEnabled = false
        if #available(iOS 13.0, *) {
            triggerStopwatchButton.setImage(UIImage(systemName: "pause.circle.fill"), for: UIControl.State.normal)
        }
    }
    
    func onStop() {
        resetCountdownLabel()
        updateNextStopwatchLabel()
    }
    
    func onPause() {
        if #available(iOS 13.0, *) {
            triggerStopwatchButton.setImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
        }
    }
    
    func onResume() {
        if #available(iOS 13.0, *) {
            triggerStopwatchButton.setImage(UIImage(systemName: "pause.circle.fill"), for: UIControl.State.normal)
        }
    }
    
    func onUpdate() {
        updateRunningStopwatchLabel()
    }
    
    func onNextStopwatch() {
        updateNextStopwatchLabel()
    }
    
    func updateNextStopwatchLabel() {
        var nextStopwatchLength : Double?
        if stopwatchManager.currentStopwatch == nil {
            nextStopwatchLength = stopwatchManager.getNextStopwatchLength(index: 0)
        }
        else {
            nextStopwatchLength = stopwatchManager.getNextStopwatchLength()
        }
        
        if nextStopwatchLength != nil {
            let (h, m, s) = stopwatchManager.secondsToHoursMinutesSeconds(seconds: nextStopwatchLength!)
            nextStopwatchLengthLabel.text = String(format:"%02d:%02d:%02d", h, m, s)
        }
        else {
            nextStopwatchLengthLabel.text = "None"
        }
    }
    
    func onStopwatchFinish() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditTimerSegue" {
            if let destinationVC = segue.destination as? StopwatchAddViewController {
                destinationVC.stopwatchManager = stopwatchManager
            }
        }
    }
    
}

