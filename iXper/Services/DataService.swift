//
//  DataService.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 22/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

let DB_BASE = Database.database().reference()

class DataService{
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUserData(forUid uid: String) -> Observable<User>{
        
        return Observable<User>.create{ observer in
            self.getUserData(forUid: uid){ (user) in
                observer.onNext(user)
            }
            return Disposables.create()
            
        }
    }
    
    private func getUserData(forUid uid: String, handler: @escaping (_ user: User ) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let fullname = value?["fullname"] as? String ?? ""
            let position = value?["position"] as? String ?? ""
            let photoUrl = value?["photoUrl"] as? String ?? ""
            let user = User(fullname: fullname, position: position, picUrl: photoUrl)
            
            handler(user)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
}
