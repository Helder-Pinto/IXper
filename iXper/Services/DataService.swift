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
import FirebaseStorage

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
    
    
    //MARK: STORE DATA IN FIREBASE
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        
        DataService.refUsers.child(uid).updateChildValues(userData)
    }
    
    func createTimeSheet(uid: String, timeSheetData: Dictionary<String, Any>){
        
        DataService.refUsers.child(uid).child("TimeSheet").child("years").updateChildValues(timeSheetData)
    }
    
    static func uploadImage(image: UIImage, uid: String){
        let storageReference = Storage.storage().reference().child("\(uid).png")
        
        if let uploadData = image.pngData() {
            storageReference.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                   
                    return
                }

                let size = metadata.size
              
                storageReference.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      
                        return
                    }
                    print(downloadURL.absoluteString)
                    DataService.refUsers.child(uid).updateChildValues(["photoUrl" : downloadURL.absoluteString])
                }
            }
            
        }
        
        
        
        
    }
    
    //    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
    //
    //        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
    //            return completion(nil)
    //        }
    //
    //        let metaData = StorageMetadata()
    //        metaData.contentType = "image/jpg"
    //        reference.putData(imageData, metadata: metaData, completion: { (metadata, error) in
    //            if let error = error {
    //                assertionFailure(error.localizedDescription)
    //                print("Upload failed :: ",error.localizedDescription)
    //                return completion(nil)
    //            }
    //
    //            completion(metadata.)
    //        })
    //    }
    
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
    
}
