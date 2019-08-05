//
//  FirstViewController.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 21/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var actualTime: UILabel!
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var clockInButton: ShadowButton!
    @IBOutlet weak var clockOutButton: ShadowButton!
    
    private let disposebag = DisposeBag()
    private let dateTime = DateTime()
    private let formatter = DateFormatter()
    private let viewModel = HomeViewModel()
    private let isTimerRunning = BehaviorRelay(value: false)
    private let isTimerPaused = BehaviorRelay(value: false)
    private var datafromtimesheet = [workDaysData]()
    private var counter = TimeInterval(0)
    private var timeThen: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.interval(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_: Int) in
                self?.updateTime()
            })
            .disposed(by: disposebag)
        
        isTimerRunning
            .distinctUntilChanged()
            .flatMapLatest { isRunning -> Observable<Int> in
                if isRunning {
                    return Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
                } else {
                    return Observable<Int>.just(0)
                }
            }
            .withLatestFrom(isTimerPaused) { ($0, $1) }
            .filter { t in
                !t.1
            }
            .subscribe(onNext: { [weak self] _ in
                self?.counter += 1
                self?.updateElapsedTime()
            })
            .disposed(by: disposebag)
        
        Observable.combineLatest(isTimerRunning, isTimerPaused)
            .distinctUntilChanged(==)
            .subscribe(onNext: { [weak self] (isRunning, isPaused) in
                if !(!isRunning || isPaused) {
                    self?.clockInButton.backgroundColor = #colorLiteral(red: 1, green: 0.8135027289, blue: 0, alpha: 1)
                    self?.clockInButton.setTitle("Pause", for: .normal)
                } else {
                    self?.clockInButton.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6274509804, blue: 0.4980392157, alpha: 1)
                    self?.clockInButton.setTitle("Clock In", for: .normal)
                }
            })
            .disposed(by: disposebag)
        
        showSpinner(onView: view)
        populateProfile()
        
    }
    
    private func populateProfile(){
        
        viewModel.fullname.asObservable()
            .subscribe(onNext: {  [weak self] fullname in
                self?.userName.text = fullname
            })
            .disposed(by: disposebag)
        //        viewModel.yearRelay.asObservable()
        //            .subscribe(onNext: {  [weak self] year in
        //                self?.userName.text = year
        //            })
        //            .disposed(by: disposebag)
        
        viewModel.position.asObservable()
            .subscribe(onNext:{ [weak self] position in
                self?.position.text = position
            })
            .disposed(by: disposebag)
        viewModel.image.asObservable()
            .subscribe(onNext: { [weak self] image in
                self?.profilePicture.image = image
            })
            .disposed(by: disposebag)
        
        Observable
            .combineLatest(viewModel.fullname, viewModel.position, viewModel.image) {
                $0 != nil && $1 != nil && $2 != nil
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isDone in
                if isDone {
                    self?.removeSpinner()
                }
            })
            .disposed(by: disposebag)
        
    }
    
    @objc func updateTime(){
        let date = dateTime.updateTime()
        actualTime.text = date.actualTime
        todaysDate.text = date.currentDayOfTheWeek + ", \(date.currentMonth) \(date.day)"
    }
    
    
    //update elapsed time label
    @objc func updateElapsedTime() {
        formatter.dateFormat = "mm:ss:SS"
        elapsedTime.text = formatter.string(from: Date(timeIntervalSince1970: counter))
        
    }
    
    
    //    MARK: IBACTIONS
    
    @IBAction func logOutBtn(_ sender: Any) {
        AuthService.instance.logoutUser()
    }
    
    @IBAction func clockInAndPause(_ sender: Any) {
        
        if let activity = clockInButton.currentTitle {
            viewModel.createTimeSheet(activity: activity, record: dateTime.updateTime().actualTime)
        }
        

        
        if !isTimerRunning.value {
            counter = 0
            isTimerRunning.accept(true)
            timeThen = dateTime.updateTime().actualTime
           
            
        } else {
            isTimerPaused.accept(!isTimerPaused.value)
        }
    }
    
    
    @IBAction func clockOut(_ sender: Any) {
        
        if let activity = clockOutButton.currentTitle {

            viewModel.createTimeSheet(activity: activity, record: dateTime.updateTime().actualTime)
           
            let record = dateTime.getDateDiff(start: timeThen!, end: dateTime.updateTime().actualTime)
            viewModel.createTimeSheet(activity: "Hours", record: record)
            
        }
        isTimerRunning.accept(false)
        dateTime.stop()

        
    }
    
    
  
    
    
}

