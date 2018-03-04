//
//  LoginViewController.swift
//  DirectionsToIndianCities
//
//  Created by rakshith appaiah on 3/3/18.
//  Copyright © 2018 rakshith appaiah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lowerImage: UIImageView!
    
    var users = [User]()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.zoomInZoomOut()
        self.schedulingzoomInZoomOut()
         /// Populating UsersList from FireBase.
        HelperClass.dbReference.child(Constants.Users).observe(.childAdded, with: { (data) in
            if let userData = data.value as? AnyObject  {
                let user = User()
                user.name = userData["name"] as? String
                user.password = userData["password"] as? String
                self.users.append(user)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.users = [User]()
        userName.text = ""
        password.text = ""
    }
    
    /// signIn button tap
    @IBAction func signIn(_ sender: Any) {
        if userName.text != "" && password.text != "" {
            self.signTapped(userName: userName.text!, password: password.text!,usersList: self.users)
        }else {
            self.alertMessage(message: Constants.credIncorrect)
        }
    }
}

extension LoginViewController {
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: Constants.Error, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Compares typed username and password with the local list created from FireBase.
    func signTapped(userName: String,password: String,usersList: [User]) {
        let loginAndRegisterCredential = usersList.filter({$0.name == userName && $0.password == password })
        if !loginAndRegisterCredential.isEmpty {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let citiesViewController = storyBoard.instantiateViewController(withIdentifier: "Cities") as? CitiesViewController {
                navigationController?.pushViewController(citiesViewController, animated: true)
            }
        }else {
            self.alertMessage(message: Constants.credInvalid)
        }
    }
    
    /// Tap on view to Collapse the Keypad.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
}

extension Sequence where Iterator.Element: Hashable {
    
    func unique() -> [Iterator.Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}

