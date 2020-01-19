//
//  TimerViewController.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2019-06-05.
//  Copyright © 2019 Parker Christie. All rights reserved.
//

import Foundation
import UIKit

class StopwatchViewController : UITableViewController {
    
    var stopwatchManager: StopwatchManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stopwatchManager?.stopwatchList.count)!;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StopwatchTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StopwatchTableViewCell else {
            fatalError("The deqeued cell is not an instance of TimerTableViewCell")
        }
        
        let timer = stopwatchManager?.stopwatchList[indexPath.row]
        let (h, m, s) = (stopwatchManager?.secondsToHoursMinutesSeconds(seconds: timer!.length))!
        cell.stopwatchLabel.text = String(format:"%02d:%02d:%02d", h, m, s)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            stopwatchManager?.removeStopwatch(index: indexPath.row)
            tableView.reloadData()
        }
    }
    
}
