//
//  AuthVc.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 22/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase

import GoogleSignIn

class AuthVc: UIViewController, GIDSignInUIDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "homeScreen", sender: Any?.self)
                
                
            }
        }
    }
    
    @IBAction func emailSignInBtn(_ sender: Any) {
        let emailVc = storyboard?.instantiateViewController(withIdentifier: "EmailVc")
        present(emailVc!, animated: true, completion: nil)
    }
    
    
    
    
    
}
