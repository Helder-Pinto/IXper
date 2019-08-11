//
//  TimeSheet.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 29/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import SpreadsheetView
import RxSwift
import RxCocoa
import RxGesture

class TimeSheetController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    @IBOutlet var spreadsheet: SpreadsheetView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    private let disposeBag = DisposeBag()
    private let timeSheetData = TimeSheetViewModel()
    private let datetime = DateTimeService()
    
    private var sumTime = [Int]()
    private var totalTitles = [String]()
    private var titles = [String]()
    private var titlesColors = [UIColor]()
    private var days = [Int]()
    private var realData = [workDaysData]()
    private var totalHours: Int?
    private var monthCounter = 0
    private let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    private let oddRowColor: UIColor = .white

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spreadsheet.dataSource = self
        spreadsheet.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //SWIPE GESTURES
        view.rx.swipeGesture([.left, .right])
            .when(.recognized)
            .subscribe(onNext: {  [weak self] gesture in
                guard let self = self else {
                    return
                }
                if gesture.direction == .left {
                    self.monthCounter += 1
                    let month = self.timeSheetData.getMonth(value: self.monthCounter )
                    self.timeSheetData.currentDate.accept(month)
                    
                } else {
                    self.monthCounter -= 1
                    let month = self.timeSheetData.getMonth(value: self.monthCounter )
                    self.timeSheetData.currentDate.accept(month)
                }
            }).disposed(by: disposeBag)
        
        timeSheetData.currentDate
            .subscribe(onNext: { [weak self] month in
                guard let self = self else {
                    return
                }
                self.navTitle.title = "\(month) \(self.datetime.year)"
            })
            .disposed(by: disposeBag)
        
        timeSheetData.currentDate
            .subscribe(onNext: { [weak self] month in
                guard let self = self else {
                    return
                }
                self.days = [Int](1...self.datetime.monthDays(month))
            })
            .disposed(by: disposeBag)
        
  
        
        
        
        
        titles = ["Clock in","Clock out", "Break", "Hours"]
        titlesColors = [UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                        UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                        UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                        UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1)
        ]
        
        spreadsheet.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        spreadsheet.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheet.gridStyle = .none
        spreadsheet.register(DatesCell.self, forCellWithReuseIdentifier: String(describing: DatesCell.self))
        spreadsheet.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheet.register(Time.self, forCellWithReuseIdentifier: String(describing: Time.self))
        spreadsheet.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheet.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
        timeSheetData.sheetData
            .subscribe(onNext: { [weak self] workdata in
                self?.realData = workdata
                self?.spreadsheet.reloadData()
            })
            .disposed(by: disposeBag)
        
        timeSheetData.sheetData
            .subscribe(onNext: { [weak self] workdata in
                let totalHours = workdata.reduce(0, { (result, data) in
                    result + (Int(data.hours) ?? 0)
                })
                print(totalHours)
            })
            .disposed(by: disposeBag)
        totalTitles = ["Total Days: \(totalHours ?? 0)", "Total Hours: 80", "", "CutOff Day: 24"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheet.flashScrollIndicators()
        
        
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
        
        
        if case (1...(totalTitles.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DatesCell.self), for: indexPath) as! DatesCell
            cell.label.text = totalTitles[indexPath.column - 1]
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
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: Time.self), for: indexPath) as! Time
            cell.label.text = String(days[indexPath.row - 2])
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
            
            
        }
        for i in 0..<realData.count{
            if case (1...(titles.count + 1), Int(realData[i].day)! + 1) = (indexPath.column, indexPath.row){
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                var text = ""
                
                switch indexPath.column {
                case 1:
                    text = realData[i].clocktIn
                case 2:
                    text = realData[i].clockOut
                case 3:
                    text = realData[i].pause
                case 4:
                    text = realData[i].hours
                default:
                    break
                }
                
                if case (1, Int(realData[i].day)! + 1) = (indexPath.column, indexPath.row) {
                }
                
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
            
        }
        
        if case (1...(titles.count + 1), 2...(days.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            cell.label.text = nil
            cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            cell.borders.top = .none
            cell.borders.bottom = .none
            
            return cell
        }
        return nil
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
        if indexPath.row > 1 {
            performSegue(withIdentifier: "ShowEditSheetSegue", sender: indexPath.row)
        }


    }
    
 
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? EditSheetViewController {
            let index = sender as? Int
            if let day = index {
                controller.day = String(day-1)
                for data in realData {
                    if data.day == String(day-1) {
                        controller.sheetData = [data]
                    
                    }
                }
            }
            timeSheetData.currentDate
                .subscribe(onNext: {  month in
                    controller.month = month
                })
                .disposed(by: disposeBag)
        }


    }
    
    
}
