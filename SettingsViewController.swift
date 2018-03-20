//
//  SettingsViewController.swift
//  markApp
//
//  Created by John Cotton on 10/16/16.
//  Copyright © 2016 John Cotton. All rights reserved.
//

import UIKit
import Foundation
import MessageUI



class SettingsViewController: UIViewController,  MFMailComposeViewControllerDelegate, UITextViewDelegate{
 
    
    
    @IBOutlet weak var productionTextField: UITextField!
    
    
    @IBOutlet weak var directorTextField: UITextField!
    
    
    
    @IBOutlet weak var dopTextField: UITextField!
    
    
    @IBOutlet weak var fpsNumberLabel: UILabel!
    
    
    
    @IBOutlet weak var fpsStepper: UIStepper!
    
    @IBAction func fpsStepperButton(_ sender: UIStepper) {
        self.fpsNumberLabel.text = Int(sender.value).description
        
    }

    @IBAction func productionFieldEdited(_ sender: UITextField) {
        production = productionTextField.text!
       
    
    }
    
    
    @IBAction func directorFieldEdited(_ sender: UITextField) {
        director = directorTextField.text!
        
    }
    
    
    @IBAction func dopFieldEdited(_ sender: UITextField) {
        dop = dopTextField.text!
    }
    
    
    let settingsPrefs = UserDefaults.standard
    
    var production: String = ""
    
    var director: String = ""
    
    var dop: String = ""
    
    
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
        
    }
    

    
 
    
    

    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fps = settingsPrefs.string(forKey:"fps"){
            fpsStepper.value = Double(fps)!
            fpsNumberLabel.text = fps
        }
      // connect textfields
        UITextField.connectFields(fields: [productionTextField, directorTextField, dopTextField])
       
       
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
      }
        
}

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["john@1080people.com"])
        mailComposerVC.setSubject("Support: Mark App for iOS")
        mailComposerVC.setMessageBody("Please leave us a description of your support needs.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController..
        // Pass the selected object to the new view controller.
    }
    */
  
    override func viewWillDisappear(_ animated: Bool) {
     
        settingsPrefs.setValue(fpsNumberLabel.text, forKey: "fps")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           //SAVE FPS, and TextField Values
        if segue.identifier == "backToMain" {
            let viewController = segue.destination as! ViewController
          
            if self.production != "" {viewController.prefs.setValue(productionTextField.text, forKey: "productionTextFieldEntered")}             
            
            if self.director != "" {viewController.prefs.setValue(directorTextField.text, forKey: "directorTextFieldEntered")}
            if self.dop != "" {viewController.prefs.setValue(dopTextField.text, forKey: "dopTextFieldEntered")}
            
            
            viewController.prefs.setValue (fpsNumberLabel.text, forKey:"fps")
        
        
        }
        
        
        
        }

}
// extension for textfield navigation - NEXT and DONE buttons
extension UITextField {
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}

