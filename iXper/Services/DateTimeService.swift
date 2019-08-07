//
//  CalendarModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 06/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation
import UIKit

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
        return calendar.weekdaySymbols[weekdayUnit]
    }
    var monthDays: Int{
        if let interval = calendar.dateInterval(of: .month, for: date) {
            return calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0}
        return 0}
    var time: String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())}
}
