//
//  EmailVc.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 22/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase

class EmailViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        if email.text != nil && password.text != nil {
            AuthService.instance.loginUser(withEmail: email.text!, andPassword: password.text!) { (success, loginError) in
                if success {
                    self.performSegue(withIdentifier: "tohomeScreen", sender: Any?.self)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                    
                }
                
            }
        }
        
    }
    
}



//                AuthService.instance.createNewUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
//                    if success {
//                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginCompleted: { (success, nil) in
//                            print(Auth.auth().currentUser?.email)
//                            self.dismiss(animated: true, completion: nil)
//
//                        })
//                    } else{
//                        print(String(describing: registrationError?.localizedDescription))
//                    }
//                })
