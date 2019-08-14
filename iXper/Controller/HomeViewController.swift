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

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var actualTime: UILabel!
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var clockInButton: ShadowButton!
    @IBOutlet weak var clockOutButton: ShadowButton!
    
    private let datetime = DateTimeService()
    private let bag = DisposeBag()
    private let formatter = DateFormatter()
    private let viewModel = HomeViewModel()
    private let timeSheet = TimeSheetViewModel()
    
    private let isTimerRunning = BehaviorRelay(value: false)
    private let isTimerPaused = BehaviorRelay(value: false)
    
    private var datafromtimesheet = [WorkDaysData]()
    private var counter = TimeInterval(0)
    private var timeThen: String?
    private var elapsed = ElapsedTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockOutButton.isEnabled = false
        clockOutButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        inAndOutButtons()
        
        Observable.interval(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_: Int) in
                self?.updateTime()
            })
            .disposed(by: bag)
        
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
            .disposed(by: bag)
        
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
            .disposed(by: bag)
        
        showSpinner(onView: view)
        populateProfile()
        elapsedTime.text = "00:00:00"
        
    }
    
    private func populateProfile(){
        
        viewModel.fullname.asObservable()
            .subscribe(onNext: {  [weak self] fullname in
                self?.userName.text = fullname
            })
            .disposed(by: bag)
        
        viewModel.position.asObservable()
            .subscribe(onNext:{ [weak self] position in
                self?.position.text = position
            })
            .disposed(by: bag)
        viewModel.image.asObservable()
            .subscribe(onNext: { [weak self] image in
                self?.profilePicture.image = image
            })
            .disposed(by: bag)
        
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
            .disposed(by: bag)
        
    }
    
    @objc func updateTime(){
        actualTime.text = datetime.time
        todaysDate.text = datetime.weekDay + ", \(datetime.month.prefix(3)) \(datetime.day)"
    }
    
    //update elapsed time label
    @objc func updateElapsedTime() {
        formatter.dateFormat = "mm:ss:SS"
        elapsedTime.text = formatter.string(from: Date(timeIntervalSince1970: counter))
        
    }
    
    //    MARK: IBactions
    @IBAction func logOutBtn(_ sender: Any) {
        AuthService.instance.logoutUser()
    }
    private func inAndOutButtons() {
        let clockIn = clockInButton.rx.tap.share()
        
        clockIn
            .bind{ [weak self] _ in
                guard let self = self else {
                    return
                }
                self.clockOutButton.isEnabled = true
                self.clockOutButton.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.1131495762, alpha: 1)
                if let activity = self.clockInButton.currentTitle {
                    self.viewModel.createTimeSheet(activity: activity, record: self.datetime.time)
                }
                if !self.isTimerRunning.value {
                    self.counter = 0
                    self.isTimerRunning.accept(true)
                    self.timeThen = self.datetime.time
                } else {
                    self.isTimerPaused.accept(!self.isTimerPaused.value)
                }
            }
            .disposed(by: bag)
        
        clockOutButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else {
                    return
                }
                self.clockOutButton.isEnabled = false
                self.clockOutButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                
                if let activity = self.clockOutButton.currentTitle {
                    self.viewModel.createTimeSheet(activity: activity, record: self.datetime.time)
                    
                }
                self.isTimerRunning.accept(false)
                self.elapsed.stop()
                self.elapsedTime.text = "00:00:00"
                
        }
       .disposed(by: bag)
    }

    
    @IBAction func photoLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
        picker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePicture.image = selectedImage
            DataService.uploadImage(image: selectedImage, uid: Auth.auth().currentUser!.uid)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

