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
    
    private static var _REF_BASE = DB_BASE
    private static var _REF_USERS = DB_BASE.child("users")
    
    static var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    static var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        
        DataService.REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUserData(forUid uid: String) -> Observable<User>{
        
        return Observable<User>.create { observer in
            DataService.getUserData(forUid: uid, onSuccess: { (user) in
                observer.onNext(user)
                observer.onCompleted()
            }) { error in
                observer.onError(error)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private static func getUserData(forUid uid: String, onSuccess: @escaping (_ user: User ) -> Void, onError: @escaping (_: Error) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let fullname = value?["fullname"] as? String ?? ""
            let position = value?["position"] as? String ?? ""
            let photoUrl = value?["photoUrl"] as? String ?? ""
            let user = User(fullname: fullname, position: position, picUrl: photoUrl)
            
            onSuccess(user)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            onError(error)
        }
        
    }
    
    
}
