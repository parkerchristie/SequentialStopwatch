//
//  StopwatchManagerListener.swift
//  SequentialStopwatch
//
//  Created by Parker Christie on 2020-01-13.
//  Copyright © 2020 Parker Christie. All rights reserved.
//

import Foundation

protocol StopwatchManagerListener : class {
    func onStart()
    func onStop()
    func onPause()
    func onResume()
    func onUpdate()
    func onNextStopwatch()
    func onStopwatchFinish()
}
