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

class HomeScreen: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var actualTime: UILabel!
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var clockInBtn: ShadowBtn!
   
    let disposebag = DisposeBag()
    let dateTime = DateTime()
    var toggle = true
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.showSpinner(onView: self.view)
       
        
        DataService.instance.getUserData(forUid: Auth.auth().currentUser!.uid)
            .subscribe(onNext: { user in
                
                self.userName.text = user.fullname
                           self.positionLabel.text = user.position
                
                
                            guard let url = URL(string: user.picUrl) else {
                                print("no profile picture found")
                                return
                            }
                            //fetching the profile image from firebase
                            DispatchQueue.global().async {
                                [weak self] in
                                if let data = try? Data(contentsOf: url){
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            self?.profilePicture.image = image
                
                
                                            self!.removeSpinner()
                                        }
                                    }
                                }
                                }

        }).disposed(by: disposebag)
        
        // user data to the homescreen
//        DataService.instance.getUserData(forUid: Auth.auth().currentUser!.uid) { (user) in
//            self.userName.text = user.fullname
//            self.positionLabel.text = user.position
//
//
//            guard let url = URL(string: user.picUrl) else {
//                print("no profile picture found")
//                return
//            }
//            //fetching the profile image from firebase
//            DispatchQueue.global().async {
//                [weak self] in
//                if let data = try? Data(contentsOf: url){
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self?.profilePicture.image = image
//
//
//                            self!.removeSpinner()
//                        }
//                    }
//
//                }
//            }
//
//        }
    }
    
    @objc func updateTime(){
        let date = Date()
        //let format = DateFormatter()
        // current date
        let calendar = Calendar.current
        //let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let weekday = calendar.component(.weekday, from: date)
        
        switch minutes{
        case 0..<10 :
            actualTime.text = "\(hour):0\(minutes)"
        default:
            actualTime.text = "\(hour):\(minutes)"
        }
        
        let currentMonth = dateTime.actualMonth(month: month)
        let currentDayOfTheWeek = dateTime.dayOfTheWeek(weekday: weekday)
        todaysDate.text =  currentDayOfTheWeek + ", \(currentMonth) \(day)"
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        AuthService.instance.logoutUser()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func clockInAndPause(_ sender: Any) {
        
        if toggle {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
            dateTime.start()
            clockInBtn.backgroundColor = #colorLiteral(red: 1, green: 0.8135027289, blue: 0, alpha: 1)
            clockInBtn.setTitle("Pause", for: .normal)
            toggle = false
            
        } else {
            
            clockInBtn.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.6274509804, blue: 0.4980392157, alpha: 1)
            clockInBtn.setTitle("Clock In", for: .normal)
            toggle = true
        }
    }
    
    
    @IBAction func clockOut(_ sender: Any) {
        dateTime.stop()
        
    }
    
    
    //update elapsed time label
    @objc func updateElapsedTime(timer: Timer) {
         formatter.dateFormat = "mm:ss:SS"
        
        if dateTime.isRunning {
            elapsedTime.text = formatter.string(from: Date(timeIntervalSince1970: dateTime.elapsedTime))
        }
        else {
            timer.invalidate()
        }
    }

}

