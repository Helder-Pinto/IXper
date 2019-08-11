//
//  TimeSheetViewModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 02/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class TimeSheetViewModel {
    
    private let datetime = DateTimeService()
    private let disposeBag = DisposeBag()
    public let currentDate = BehaviorRelay(value: DateTimeService.init().month)
    
    public var sheetData: Observable<[workDaysData]> {
        return currentDate
            .flatMapLatest { month in
                self.getSheetData(month: month)
        }
    }
    
    init() {
        
    }
    
    
    func getSheetData(month: String) -> Observable<[workDaysData]> {
        
        let query = DataService.refUsers.child(Auth.auth().currentUser!.uid).child("TimeSheet").child("years").child(String(datetime.year)).child(month)
        
        return Observable.create { (observer)  in
            
            let handle = query.observe(.value) { (snapshot) -> Void in
                
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                var daysOfWorkArray = [workDaysData]()
                
                for days in snapshot {
                    var clockIn = ""
                    var clockOut = ""
                    var pauseTime = ""
                    var hours = ""
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
                    
                    if days.childSnapshot(forPath: "Hours").exists() {
                        hours = days.childSnapshot(forPath: "Hours").value as! String
                    }
                    
                    let capturedData = workDaysData(day: day, clocktIn: clockIn, clockOut: clockOut, pause: pauseTime, hours: hours)
                    
                    daysOfWorkArray.append(capturedData)
                }
                
                observer.onNext(daysOfWorkArray)
            }
            
            return Disposables.create {
                query.removeObserver(withHandle: handle)
            }
        }
    }
    
    func getMonth(value: Int) -> String {
        if let month = Calendar.current.date(byAdding: .month, value: value, to: Date()) {
            let monthUnit = Calendar.current.component(.month, from: month)
            return Calendar.current.monthSymbols[monthUnit-1]
        }
        return ""
    }
    
    func createSheetDate(month: String, day: String, activity: String, record: String){
        
        let path = ["/\(self.datetime.year)/\(month)/\(day)/\(activity)":"\(record)"]
        if let uid = Auth.auth().currentUser?.uid {
            DataService.instance.createTimeSheet(uid: uid, timeSheetData: path)
        }
    }
}

