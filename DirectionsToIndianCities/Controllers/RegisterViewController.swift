//
//  RegisterViewController.swift
//  DirectionsToIndianCities
//
//  Created by rakshith appaiah on 3/3/18.
//  Copyright © 2018 rakshith appaiah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lowerImage: UIImageView!
    
    var dbReference: DatabaseReference?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zoomInZoomOut()
        self.schedulingzoomInZoomOut()
    }
    
    /// popping RegisterViewController.
    @IBAction func backToLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    /// register button action.
    @IBAction func registerTapped(_ sender: Any) {
        if username.text != "" && password.text != "" {
            let diceRoll = "\(arc4random_uniform(6))"
            let userReference = HelperClass.dbReference.child("Users").child(diceRoll)
            let valued = ["name": username.text!,"password": password.text!]
            userReference.onDisconnectUpdateChildValues(valued, withCompletionBlock: { (err, ref) in
                if err == nil {
                    self.alertMessage(message: Constants.registerSuccess, title: Constants.Success)
                }
            })
        }else {
            self.alertMessage(message: Constants.credValid, title: Constants.Error)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        username.text = ""
        password.text = ""
    }
}

extension RegisterViewController {
    
    func alertMessage(message: String,title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Animates the background image in Login Screen.
    @objc func zoomInZoomOut() {
        UIView.animate(withDuration: 15.0, animations: {() -> Void in
            self.lowerImage?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 20.0, animations: {() -> Void in
                self.lowerImage?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    /// Scheduling of animatation of the background image.
    private func schedulingzoomInZoomOut() {
        timer = Timer.scheduledTimer(timeInterval: 35,
                                     target: self,
                                     selector: #selector(self.zoomInZoomOut),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    /// Tap on view to Collapse the Keypad.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

