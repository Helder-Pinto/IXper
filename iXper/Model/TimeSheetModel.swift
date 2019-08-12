//
//  TimeSheetModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 03/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit


struct TimeSheet {
    var totalHours: Int
    var totalDays: Int
}

struct WorkDaysData {
    var day: String
    var clocktIn: String
    var clockOut: String
    var pause: String
    var hours: String
}

struct TotalData {
    var totalDays: Int
    var totalHours: Int
    var cuttoffDay = 24
}

struct Titles {
    var titles: [String]
    var titleColors: [UIColor]
    var totalTitles: [String]
}




