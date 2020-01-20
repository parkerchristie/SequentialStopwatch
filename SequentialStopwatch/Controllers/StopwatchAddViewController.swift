//
//  EditTimerController.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2020-01-09.
//  Copyright © 2020 Parker Christie. All rights reserved.
//

import Foundation
import UIKit

class StopwatchAddViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var stopwatchManager: StopwatchManager?
    
    @IBOutlet weak var inputTimer: UIPickerView!
    
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTimer.delegate = self
        self.inputTimer.dataSource = self
    }
    
    @IBAction private func addTimer(sender: UIButton) {
        var timeToAdd : Int = 0
        timeToAdd += seconds
        timeToAdd += minutes * 60
        timeToAdd += hours * 3600
        if (timeToAdd > 0) {
            stopwatchManager?.addStopwatch(length: Double(timeToAdd))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTimerListSegue" {
            if let destinationVC = segue.destination as? StopwatchViewController {
                destinationVC.stopwatchManager = stopwatchManager
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3.5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hr"
        case 1:
            return "\(row) Min"
        case 2:
            return "\(row) Sec"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hours = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break;
        }
    }
    
}
