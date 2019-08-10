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
    private var testCounter = 0
    private let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    private let oddRowColor: UIColor = .white
    override func viewDidLoad() {
        super.viewDidLoad()
        spreadsheet.dataSource = self
        spreadsheet.delegate = self

        
        //SWIPE GESTURES
        
//        testing
        view.rx.swipeGesture([.left, .right])
            .when(.recognized)
            .subscribe(onNext: {  [weak self] gesture in
//                guard let self = self else {
//                    return
//                }
                
                if gesture.direction == .left {
                    self?.testCounter += 1
                    let month = self?.getMonth(value: self?.testCounter ?? 0)
                    self?.timeSheetData.currentDate.accept(month ?? Date())

//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "LLLL"
//                    let nameOfMonth = dateFormatter.string(from: now!)
//                    self?.navTitle.title = nameOfMonth + " \(self!.datetime.year)"
//                    self?.spreadsheet.reloadData()
                    
//                    self?.timeSheetData.getSheetTestData(month: nameOfMonth)
//                        .subscribe(onNext: { [weak self] workdata in
//                            self?.realData = workdata
//                            self?.spreadsheet.reloadData()
//                        })
//                        .disposed(by: self!.disposeBag)
//
                    
                    
                } else {
                    self?.testCounter -= 1
                    let month = self?.getMonth(value: self?.testCounter ?? 0)
                    self?.timeSheetData.currentDate.accept(month ?? Date())
                    
                    
//                    self?.testCounter -= 1
//                    let now = self?.getNextMonth(value: self?.testCounter ?? 0)
//
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "LLLL"
//                    let nameOfMonth = dateFormatter.string(from: now!)
//                    self?.navTitle.title = nameOfMonth + " \(self!.datetime.year)"
//                    self?.spreadsheet.reloadData()
////
//                    self?.timeSheetData.getSheetTestData(month: nameOfMonth)
//                        .subscribe(onNext: { [weak self] workdata in
//                            self?.realData = workdata
//                            self?.spreadsheet.reloadData()
//                        })
//                        .disposed(by: self!.disposeBag)
                }
            }).disposed(by: disposeBag)
    
        
        
        
        
        navTitle.title = "\(datetime.month) \(datetime.year)"
        days = [Int](1...datetime.monthDays)
        navigationController?.navigationBar.prefersLargeTitles = true
      
        
        
        totalTitles = ["Total Days: \(totalHours ?? 0)", "Total Hours: 80", "", "CutOff Day: 24"]
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
            })
            .disposed(by: disposeBag)

        
//        timeSheetData.getSheetData()
//            .subscribe(onNext: { [weak self] workdata in
//                self?.realData = workdata
//                self?.spreadsheet.reloadData()
//            })
//            .disposed(by: disposeBag)
      
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
                    
                    
//                    sumTime.append((Int(realData[i].hours)!))
//                    print(sumTime.reduce(0, +))
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
    
    /// Delegate
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
        
       
        }
    
    func getMonth(value: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: value, to: Date())
    }
    
  
 
}
