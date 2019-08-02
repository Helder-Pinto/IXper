//
//  TimeSheetViewModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 31/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class WorkingDataViewModel {
    
  
    private let dateTime = DateTime()
    
   
    
    
    init(activity: String) {
        
        let year = String(dateTime.updateTime().year)
        let month = dateTime.updateTime().currentMonth
        let day = String(dateTime.updateTime().day)
        let actualTime = dateTime.updateTime().actualTime
       
        
        if let uid = Auth.auth().currentUser?.uid {
            DataService.instance.createTimeSheet(uid: uid, timeSheetData: ["/TimeSheet/years/\(year)/\(month)/\(day)/\(activity)":"\(actualTime)"])
        }
        
     }
}
    
    
    
    
