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
    
  
     let dateTime = DateTime()
    
    static var ref: DatabaseReference {
        return databaseReference
    }
    
    static var refUsers : DatabaseReference {
        return usersReference
    }
    
    
    //MARK: STORE DATA IN FIREBASE
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        
        DataService.refUsers.child(uid).updateChildValues(userData)
    }
    
    func createTimeSheet(uid: String, timeSheetData: Dictionary<String, Any>){
        
        DataService.refUsers.child(uid).updateChildValues(timeSheetData)
    }
    
    
    

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
            let user = User(fullname: fullname, position: position, picUrl: photoUrl)
            
            onSuccess(user)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            onError(error)
        }
        
    }
    
    
    
    
    
    //    func getSheetData() -> Observable<[workDaysData]> {
    //
    //        return Observable.create({ (observer) -> Disposable in
    //            DataService.getSheetData(handler: { (workDaysData) in
    //                observer.onNext(workDaysData)
    //                observer.onCompleted()
    //            }) { error in
    //                observer.onError(error)
    //                observer.onCompleted()
    //            }
    //            return Disposables.create()
    //
    //        })
    //    }
////    , onError: @escaping (_: Error) -> Void) 
//    func getSheetData(forUid uid: String, handler: @escaping (_ daysOfWorkArray : [workDaysData]) -> ()){
//       
//        var daysOfWorkArray = [workDaysData]()
//        DataService.refUsers.child(uid).child("TimeSheet").child("years").child(String(dateTime.updateTime().year)).child(dateTime.updateTime().currentMonth).observe(.value, with: { (snapshot) -> Void in
//            
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
//            for days in snapshot {
//                
//                var pauseTime = ""
//                let day = days.key
//                let clockIn = days.childSnapshot(forPath: "Clock In").value as! String
//                let clockOut = days.childSnapshot(forPath: "Clock Out").value as! String
//                if days.childSnapshot(forPath: "Pause").exists() {
//                    pauseTime = days.childSnapshot(forPath: "Pause").value as! String
//                }
//                let capturedData = workDaysData(day: day, clocktIn: clockIn, clockOut: clockOut, pause: pauseTime )
//                daysOfWorkArray.append(capturedData)
//            }
//        })
//        handler(daysOfWorkArray)
//        
//    }
    
}
