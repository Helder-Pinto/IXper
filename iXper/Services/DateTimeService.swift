//
//  CalendarModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 06/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct DateTimeService {
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var month: String {
        let monthUnit = calendar.component(.month, from: date)
        return calendar.monthSymbols[monthUnit-1]}
    
    var year: Int {
        return calendar.component(.year, from: date)}
    
    var day: Int {
        return calendar.component(.day, from: date)}
    
    var weekDay: String {
        let weekdayUnit = calendar.component(.weekday, from: date)
        return calendar.weekdaySymbols[weekdayUnit-1]
    }
    
    var monthDays: Int{
        if let interval = calendar.dateInterval(of: .month, for: date) {
            return calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0}
        return 0}
    
    var time: String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())}
    
    
    func timeDifference(start: String, end: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        
        if let timeThen = dateFormatter.date(from: start), let timeNow = dateFormatter.date(from: end) {
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute], from: timeThen, to: timeNow)
          
            let date = calendar.date(from: dateComponents)!
            return dateFormatter.string(from: date)
                
            }
        return ""
    }
            // Number of days in a month
            func monthDays(_ month: String) -> Int {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                guard let date = dateFormatter.date(from: month) else {return
                    calendar.component(.month, from: Date())}
                if let interval = calendar.dateInterval(of: .month, for: date)
                {
                    return calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0}
                return 0}
            
}
