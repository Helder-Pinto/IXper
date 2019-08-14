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
    private(set) var titles = [Titles]()
    public let currentDate = BehaviorRelay(value: DateTimeService.init().month)
    
    
    
    public var sheetData: Observable<[WorkDaysData]> {
        return currentDate
            .flatMapLatest { month in
                getSheetData(month: month)
        }
    }
    
    init() {
        titles = [Titles(titles: ["Clock in","Clock out", "Break", "Hours"],
                         titleColors: [UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                                       UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                                       UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                                       UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1)],
                         totalTitles: ["Total Days: 0", "Total Hours: 0", "", "CutOff Day: 24"])]
    }
    
    

    
    func getMonth(value: Int) -> String {
        if let month = Calendar.current.date(byAdding: .month, value: value, to: Date()) {
            let monthUnit = Calendar.current.component(.month, from: month)
            return Calendar.current.monthSymbols[monthUnit-1]
        }
        return ""
    }
    
    func updateSheetData(month: String, day: String, activity: String, record: String){
        let path = ["/\(self.datetime.year)/\(month)/\(day)/\(activity)":"\(record)"]
        if let uid = Auth.auth().currentUser?.uid {
            DataService.instance.createTimeSheet(uid: uid, timeSheetData: path)
        }
    }
}

func getSheetData(month: String) -> Observable<[WorkDaysData]> {
    let datetime = DateTimeService()
    let query = DataService.refUsers.child(Auth.auth().currentUser!.uid).child("TimeSheet").child("years").child(String(datetime.year)).child(month)
    
    return Observable.create { [datetime] (observer)  in
        
        let handle = query.observe(.value) { (snapshot) -> Void in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            var daysOfWorkArray = [WorkDaysData]()
            
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
                
                hours = datetime.timeDifference(start: clockIn, end: clockOut)
                
                
                let capturedData = WorkDaysData(day: day, clocktIn: clockIn, clockOut: clockOut, pause: pauseTime, hours: hours)
                
                daysOfWorkArray.append(capturedData)
            }
            
            observer.onNext(daysOfWorkArray)
        }
        
        return Disposables.create {
            query.removeObserver(withHandle: handle)
        }
    }
}

