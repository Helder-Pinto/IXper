//
//  TimeSheet.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 29/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SpreadsheetView


class TimeSheet: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    @IBOutlet var spreadsheetView: SpreadsheetView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    let datetime = DateTime()
    
    let dates = ["Total Days: 15", "Total Hours: 80", "", "CutOff Day: 24"]
    let titles = ["Clock in", "Pause", "Resume", "Clock out"]
    let titlesColors = [UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                        UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                        UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                        UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1)]
    let days = ["25 Thu", "26 Fri", "27 Sat", "28 Sun", "29 Mon", "30 Tue", "31 Wed", "1 Thu", "2 Fri",
                "3 Sat", "4 Sun", "5 Mon", "6 Tue", "7 Wed", "8 Thu", "9 Fri", "10 Sat", "11 Sun", "12 Mon", "13 Tue", "14 Wed", "15 Thu", "16 Fri", "17 Sat", "18 Sun", "19 Mon", "20 Tue", "21 Wed", "22 Thu", "23 Fri", "24 Sat"]
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    let data = [
        ["8:00", "12:00", "13:00", "18:00"], ["8:00", "12:00", "13:00", "17:00"], ["", "", "", ""],[ "", "", "", ""] , ["9:00", "13:00", "14:00", "18:00"],
        ["8:00", "12:00", "13:00", "18:00"],[ "8:00", "12:00", "13:00", "18:00"],["9:00", "13:00", "14:00", "18:00"],["8:00", "12:00", "13:00", "17:00"],["", "", "", ""],
        ["", "", "", ""],[ "8:00", "12:00", "13:00", "16:00"],[ "", "", "", "Sick Day"],[ "", "", "", "Sick Day"],["8:00", "12:00", "13:00", "17:00"],
        ["", "", "", ""],["", "", "", ""],[ "", "", "", ""], ["", "", "", ""], ["", "", "", ""],
        ["", "", "", ""], ["", "", "", ""],[ "", "", "", ""],[ "", "", "", ""],[ "", "", "", ""],
        ["", "", "", ""],[ "", "", "", ""],[ "", "", "", ""],[ "", "", "", ""],[ "", "", "", ""],
        ["", "", "", ""]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navTitle.title = "\(date)"
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none
        
        spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }
    
    // MARK: DataSource
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + titles.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 1 + days.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 60
        } else {
            return 82
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 24
        } else if case 1 = row {
            return 32
        } else {
            return 35
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1...(dates.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.text = dates[indexPath.column - 1]
            return cell
        } else if case (1...(titles.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = titles[indexPath.column - 1]
            cell.label.textColor = titlesColors[indexPath.column - 1]
            return cell
        } else if case (0, 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            cell.label.text = "Day"
            return cell
        } else if case (0, 2...(days.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = days[indexPath.row - 2]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
        } else if case (1...(titles.count + 1), 2...(days.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            let text = data[indexPath.row - 2][indexPath.column - 1]
            if !text.isEmpty {
                cell.label.text = text
                let color = titlesColors[indexPath.column - 1]
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            return cell
        }
        return nil
    }
    
    /// Delegate
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}
