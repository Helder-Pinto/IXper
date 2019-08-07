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

struct ElapsedTime {
    
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
    
    mutating func start (){
        clockIn = Date()
    }
    
    mutating func stop(){
        clockIn = nil
    }
}


