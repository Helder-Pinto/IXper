//
//  DateTime.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 26/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation

class DateTime {
    
    
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
    
    func dayOfTheWeek(weekday: Int) -> String {
        
        switch weekday{
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
    

    
    func actualMonth(month: Int) -> String {
        
        
        switch month {
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
    
    
    
}
