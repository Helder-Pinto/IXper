//
//  AuthService.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 22/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    
    static let instance = AuthService()
    
    func createNewUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error : Error?) -> Void ) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["email" : user.email] //if theres a user we get the provider(google hotmail etc) and the email
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
            
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginCompleted: @escaping (_ status: Bool, _ error: Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard (authResult?.user) != nil else {
                loginCompleted(false, error)
                return
            }
            
            loginCompleted(true, nil)
        }
    }
    
    
    
    func logoutUser(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
}
