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

let database = Database.database().reference()

class DataService{
    
    static let instance = DataService()
    
    private static var databaseReference = database
    private static var usersReference = database.child("users")
  
    
    static var ref: DatabaseReference {
        return databaseReference
    }
    
    static var refUsers : DatabaseReference {
        return usersReference
    }
    
    
    //MARK: SEND DATA TO FIREBASE
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        
        DataService.refUsers.child(uid).updateChildValues(userData)
    }
    
    func createTimeSheet(uid: String, timeSheetData: Dictionary<String, Any>){
        
        DataService.refUsers.child(uid).updateChildValues(timeSheetData)
    }
    
   // ["/TimeSheet/years/2019/june/31/clockIn":"9:00"]
    
    
    
    
    
    
    //MARK: GET DATA FROM FIREBASE
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
        
        refUsers.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let fullname = value?["fullname"] as? String ?? ""
            let position = value?["position"] as? String ?? ""
            let photoUrl = value?["photoUrl"] as? String ?? ""
            let timeSheet = value?["TimeSheet"] as? String ?? ""
            let user = User(fullname: fullname, position: position, picUrl: photoUrl)
            
            onSuccess(user)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            onError(error)
        }
        
    }
    
}
