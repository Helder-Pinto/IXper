//
//  TimeSheetViewModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 02/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase

struct TimeSheetViewModel {
    
    private let dateTime = DateTime().updateTime()
    
    
    
    func getSheetData(handler: @escaping (_ daysOfWorkArray : [workDaysData]) -> ()){
        
        var daysOfWorkArray = [workDaysData]()
        DataService.refUsers.child(Auth.auth().currentUser!.uid).child("TimeSheet").child("years").child(String(dateTime.year)).child(dateTime.currentMonth).observe(.value, with: { (snapshot) -> Void in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for days in snapshot {
                
                var clockIn = ""
                var clockOut = ""
                var pauseTime = ""
                let day = days.key
                
                
                if days.childSnapshot(forPath: "Clock In").exists() {
                    clockIn = days.childSnapshot(forPath: "Clock In").value as! String
                }
            
                if days.childSnapshot(forPath: "Clock Out").exists() {
                    clockOut = days.childSnapshot(forPath: "Clock Out").value as! String
                }
                
               
                if days.childSnapshot(forPath: "Pause").exists() {
                    pauseTime = days.childSnapshot(forPath: "Pause").value as! String
                }
               
                
                let capturedData = workDaysData(day: day, clocktIn: clockIn, clockOut: clockOut, pause: pauseTime )
                daysOfWorkArray.append(capturedData)
            }
            handler(daysOfWorkArray)
        })
        
        
    }
    
    
    
}

