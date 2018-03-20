//
//  ViewController.swift
//  markApp
//
//  Created by John Cotton on 10/3/16.
//  Copyright © 2016 John Cotton. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextViewDelegate{
 
 
   // let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var timerIsRunning = false
    
    var fps: Int = 24
    var dateString: NSString = ""
    var timerForClock: Timer?
    var tcStartTime = TimeInterval()
    
    var tcTimer:Timer = Timer()

    var audioPlayer: AVAudioPlayer?
    
    let prefs = UserDefaults.standard
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    
    @IBOutlet weak var tcTimeLabel: UILabel!
    
    
    @IBOutlet weak var syncDisplay: UIImageView!
    
    
    @IBAction func markButton(_ sender: AnyObject) {
        if timerIsRunning == false {
                                    timerIsRunning = true
                                    startTcTimer()
                                    stopButtonOutlet.setTitle("stop", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(940), execute: {
                self.playSound()
                self.visualCue()
                
                
                })
                                    }
    }
    
    
    
    @IBAction func stopButton(_ sender: AnyObject) {
      if timerIsRunning == true {
                                tcTimer.invalidate()
                                timerIsRunning = false
                                stopButtonOutlet.setTitle("reset", for: .normal)}
      else {
                tcTimeLabel.text = "00:00:00:00"
                stopButtonOutlet.setTitle("stop", for: .normal)
            }
    }

    
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
   
    
    @IBOutlet weak var sceneNumberLabel: UILabel!
    
    
    
    
    @IBOutlet weak var shotNumberLabel: UILabel!
    
    
    
    
    @IBOutlet weak var takeNumberLabel: UILabel!
    
    
    
    
    @IBOutlet weak var sceneStepper: UIStepper!
    
    
    @IBAction func sceneStepperButton(_ sender: UIStepper) {
        self.sceneNumberLabel.text = Int(sender.value).description
    
    }
    
    @IBOutlet weak var shotStepper: UIStepper!
    
    
    @IBAction func shotStepperButton(_ sender: UIStepper) {
        self.shotNumberLabel.text = Int(sender.value).description
        
    }
    
    
    @IBOutlet weak var takeStepper: UIStepper!
    @IBAction func takeStepperButton(_ sender: UIStepper) {
         self.takeNumberLabel.text = Int(sender.value).description
        
        
    }
    
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var dopLabel: UILabel!
    

  
    
    
       override func viewDidLoad() {
        super.viewDidLoad()

               // Do any additional setup after loading the view, typically from a nib.
                setTime()
             
        if let productionLabelValue = prefs.string(forKey: "productionTextFieldEntered"){productionLabel.text = productionLabelValue}
        if let directorLabelValue = prefs.string(forKey: "directorTextFieldEntered"){directorLabel.text = directorLabelValue }
        if let dopLabelValue = prefs.string(forKey: "dopTextFieldEntered"){dopLabel.text = dopLabelValue }
      
        
        //
        
        
    }
    
// shake gesture to mark shot
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        // Code to mark on shake
        
        if timerIsRunning == false {
            timerIsRunning = true
            startTcTimer()
            self.stopButtonOutlet.setTitle("stop", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(940), execute: {
                self.playSound()
                self.visualCue()
            })
        }
    }
    
    
    // function for playing wav
    func playSound() {
        let url = Bundle.main.url(forResource: "cue blip", withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }

    
   
    
    
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
   
    
    func visualCue() {
        
        syncDisplay.alpha = 1
      //  self.syncDisplay.isHidden = false
        UIView.animate(withDuration: 0.10, delay: 0.20, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
            self.syncDisplay.alpha = 0
            }, completion: { finished in
        //        self.syncDisplay.isHidden = true
        })
        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
        if let scene = prefs.string(forKey: "sceneStepper"){
            
            
            sceneNumberLabel.text = scene
            sceneStepper.value = Double(scene)!
        }
        if let shot = prefs.string(forKey: "shotStepper"){
        shotNumberLabel.text = shot
            shotStepper.value = Double(shot)!
        }
        if let take = prefs.string(forKey: "takeStepper"){
            takeNumberLabel.text = take
            takeStepper.value = Double(take)!
        }
        
        if let fpsValue = prefs.string(forKey: "fps"){fps = Int(fpsValue)!}
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        prefs.setValue(sceneNumberLabel.text, forKey: "sceneStepper")
        prefs.setValue(shotNumberLabel.text, forKey: "shotStepper")
        prefs.setValue(takeNumberLabel.text, forKey: "takeStepper")
        

    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            _ = segue.destination as! SettingsViewController
            stopButtonOutlet.setTitle("stop", for: .normal)
            
            
            
            
            
        }
    }
    
 
 
    
    

}

