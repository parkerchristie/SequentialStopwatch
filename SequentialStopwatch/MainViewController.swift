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
    
    @IBOutlet weak var countdownTimer: UILabel!
    
    @IBOutlet weak var triggerStopwatchButton: UIButton!
    
    @IBOutlet weak var stopStopwatchButton: UIButton!
    
    @IBOutlet weak var editStopwatchButton: UIButton!
    
    @IBOutlet weak var nextStopwatchLabel: UILabel!
    @IBOutlet weak var nextStopwatchLengthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopwatchManager.delegate = self
        updateUIAppearances()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUIAppearances()
    }
    
    @IBAction func triggerStopwatches(sender: UIButton) {
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
    
    func updateUIAppearances() {
        if #available(iOS 13.0, *) {
            if !stopwatchManager.isRunning {
                var nextStopwatchLength : Int?
                nextStopwatchLength = stopwatchManager.getNextStopwatchLength()
                
                if nextStopwatchLength != nil {
                    let (h, m, s) = stopwatchManager.secondsToHoursMinutesSeconds(seconds: nextStopwatchLength!)
                    countdownTimer.text = String(format:"%02d:%02d:%02d", h, m, s)
                }
                triggerStopwatchButton.setImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
                stopStopwatchButton.isEnabled = false
                editStopwatchButton.isEnabled = true
                
            }
            if stopwatchManager.isRunning {
                triggerStopwatchButton.setImage(UIImage(systemName: "pause.circle.fill"), for: UIControl.State.normal)
                stopStopwatchButton.isEnabled = true
                editStopwatchButton.isEnabled = false
            }
            if stopwatchManager.isPaused {
                triggerStopwatchButton.setImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
            }
            updateNextStopwatchLabel()
        }
    }
    
    @IBAction func stopStopwatches(_ sender: UIButton) {
        stopwatchManager.endStopwatches()
    }
    
    @objc func updateRunningStopwatchLabel() {
        let timeRemaining = stopwatchManager.currentStopwatch?.getTimeRemaining()
        if (timeRemaining != nil) {
            let (h, m, s) = stopwatchManager.secondsToHoursMinutesSeconds(seconds: timeRemaining!)
            countdownTimer.text = String(format:"%02d:%02d:%02d", h, m, s)
        }
    }
    
    func onStart() {
        updateRunningStopwatchLabel()
        updateUIAppearances()
    }
    
    func onStop() {
        updateUIAppearances()
    }
    
    func onPause() {
        updateUIAppearances()
    }
    
    func onResume() {
        updateUIAppearances()
    }
    
    func onUpdate() {
        updateRunningStopwatchLabel()
    }
    
    func onNextStopwatch() {
        updateNextStopwatchLabel()
    }
    
    func updateNextStopwatchLabel() {
        var nextStopwatchLength : Int?
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

