//
//  EditTimeSheetViewController.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 11/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditSheetViewController: UIViewController {
    
    @IBOutlet weak var clockIn: UITextField!
    @IBOutlet weak var clockOut: UITextField!
    @IBOutlet weak var breakTextLabel: UITextField!
    @IBOutlet weak var clearButton: ShadowButton!
    @IBOutlet weak var saveButton: ShadowButton!
    
    private let timeSheet = TimeSheetViewModel()
    private let disposeBag = DisposeBag()
    var day: String = ""
    var month: String = ""
    var sheetData = [WorkDaysData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if sheetData.count == 1 {
            clockIn.text = sheetData[0].clocktIn
            clockOut.text = sheetData[0].clockOut
            breakTextLabel.text = sheetData[0].pause
        }
        saveData()
    }
    
    
    func saveData() {
        saveButton.rx.tap
            .throttle(1, scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.clockIn.text != "" {
                    self.timeSheet.updateSheetData(month: self.month, day: self.day, activity: "Clock In", record: self.clockIn.text!)
                    self.timeSheet.updateSheetData(month: self.month, day: self.day, activity: "Clock Out", record: self.clockOut.text!)
                    self.timeSheet.updateSheetData(month: self.month, day: self.day, activity: "Pause", record: self.breakTextLabel.text!)
                }
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

    }
    
    
}
