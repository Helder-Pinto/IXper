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
    
    let fullname = BehaviorRelay(value: nil as String?)
    let position = BehaviorRelay(value: nil as String?)
    let image = BehaviorRelay(value: nil as UIImage?)
    
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
    
    
    
    
 }
 
 
