 //
 //  HomeViewModel.swift
 //  iXper
 //
 //  Created by Afonso Pinto, Helder Manuel on 28/07/2019.
 //  Copyright © 2019 Helder Pinto. All rights reserved.
 //
 
 import UIKit
 import RxSwift
 import Firebase
 import RxCocoa
 
 
 class HomeViewModel {
    
    private let disposebag = DisposeBag()
    private let datetime = DateTimeService()
    
    let fullname = BehaviorRelay(value: nil as String?)
    let position = BehaviorRelay(value: nil as String?)
    let image = BehaviorRelay(value: nil as UIImage?)
    let actualTimeRelay = BehaviorRelay(value: nil as String?)
    let datafromSheet = BehaviorRelay(value: [])
    
    init() {
        let userDataObservable = DataService.instance.getUserData(forUid: Auth.auth().currentUser!.uid).share()
        
        userDataObservable
            .map { $0.fullname }
            .bind(to: fullname)
            .disposed(by: disposebag)
        
        userDataObservable
            .map { $0.position }
            .bind(to: position)
            .disposed(by: disposebag)
        
        userDataObservable
            .flatMapLatest { user -> Observable<URL> in
                if let url = URL(string: user.picUrl) {
                    
                    return Observable.just(url)
                } else {
                    return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
                }
            }
            .flatMapLatest { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                URLSession.shared.rx.response(request: URLRequest(url: url))
            }
            .flatMapLatest { response, data -> Observable<UIImage?> in
                if 200 ..< 300 ~= response.statusCode {
                    return Observable.just(UIImage(data: data))
                } else {
                    return Observable.just(nil)
                }
            }
            // subscribe on main thread
            .observeOn(MainScheduler.instance)
            .bind(to: image)
            .disposed(by: disposebag)
    }
    //    create timeSheet
    func createTimeSheet(activity: String, record: String) {
        let path = ["/\(datetime.year)/\(datetime.month)/\(datetime.day)/\(activity)":"\(record)"]
        if let uid = Auth.auth().currentUser?.uid {
            DataService.instance.createTimeSheet(uid: uid, timeSheetData: path)
        }
    }
    
    //    Time Difference - Hours worked
    func getDateDiff(start: String, end: String) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeThen = dateFormatter.date(from: start)
        let timeNow = dateFormatter.date(from: end)
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: timeThen!, to: timeNow!)
        if  let minute = dateComponents.minute, let hour = dateComponents.hour{
            switch minute{
            case 0..<10:
                return "\(hour):0\(minute)"
            default:
                return "\(hour):\(minute)"
            }
            
        }
        return ""
    }
    
    
//    func getUserData(start: String, end: String) -> Observable<String> {
//        
//    }
    
//    func getUserData(forUid uid: String) -> Observable<User>{
//
//        return Observable<User>.create { observer in
//            DataService.getUserData(forUid: uid, onSuccess: { (user) in
//                observer.onNext(user)
//                observer.onCompleted()
//            }) { error in
//                observer.onError(error)
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
    
    
    
    
 }
 
 
