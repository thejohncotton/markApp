//
//  Timer.swift
//  markApp
//
//  Created by John Cotton on 6/11/17.
//  Copyright © 2017 John Cotton. All rights reserved.
//

import Foundation
import AVFoundation


var dateString: NSString = ""
var tcStartTime = TimeInterval()
var tcTimer:Timer = Timer()
var timerForClock: Timer?

class Timer {
    
    
    func setTime(){
        timerForClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.setTime), userInfo: nil, repeats: false)
        
        let date: NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss"
        dateString = dateFormatter.string(from: date as Date) as NSString
        currentTimeLabel.text = dateString as String
    }

    
    
    func startTcTimer(){
        if (!tcTimer.isValid) {
            let aSelector : Selector = #selector(ViewController.updateTcTime)
            tcTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            tcStartTime = NSDate.timeIntervalSinceReferenceDate
        }
    }

    
    
    func updateTcTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - tcStartTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * TimeInterval(fps))
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        var strFraction: String = ""
        if fps >= 100 {strFraction = String(format: "%03d", fraction)}
        else {strFraction = String(format: "%02d", fraction)}
        
        //concatenate minutes, seconds and milliseconds as assign it to the UILabel
        tcTimeLabel.text = "00:\(strMinutes):\(strSeconds):\(strFraction)"
    }


}
