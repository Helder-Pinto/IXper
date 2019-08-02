//
//  DateTime.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 26/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DateTime {
    
    //    set timezone formatter
    private var clockIn: Date?
    
    var elapsedTime: TimeInterval{
        if let clockIn = self.clockIn {
            return -clockIn.timeIntervalSinceNow
        }
        else {
            return 0
        }
    }
    
    var isRunning: Bool{
        return clockIn != nil
    }
    
    func start (){
        clockIn = Date()
    }
    
    func stop(){
        clockIn = nil
    }
    
    private func dayOfTheWeek(for unit: Int) -> String {
        //calendar.weekdaySymbols 
        switch unit{
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            break
            
        }
        return ""
    }
    
    
    
    private func month(of unit: Int) -> String {
        
        
        switch unit {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            break
        }
        return ""
    }
    
    
    func updateTime() -> (actualTime: String, currentDayOfTheWeek: String, currentMonth: String, day: Int, previousMonth: String, nextMonth: String, year: Int, daysInCurrentMonth: Int){
        
        let date = Date()
        let calendar = Calendar.current
        let monthUnit = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let weekday = calendar.component(.weekday, from: date)
        var actualTime = ""
        let previousMonth = month(of: monthUnit - 1)
        let nextMonth = month(of: monthUnit + 1)
  
 
        
        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)!
        
        // Compute difference in days:
        let daysInCurrentMonth = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        
        
        switch minutes{
        case 0..<10 :
            actualTime = "\(hour):0\(minutes)"
        default:
            actualTime = "\(hour):\(minutes)"
        }
        
        let currentMonth = month(of: monthUnit)
        let currentDayOfTheWeek = dayOfTheWeek(for: weekday)
        
        return (actualTime, currentDayOfTheWeek, currentMonth, day, previousMonth, nextMonth, year, daysInCurrentMonth)
    }
    
    
}

