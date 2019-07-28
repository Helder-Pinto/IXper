 //
//  HomeViewModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 28/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import RxSwift

 
 class HomeViewModel {
    let user: User
    
    init(_ user: User){
        self.user = user
    }
 }
 
 extension HomeViewModel {
    var fullname: Observable<String> {
        return Observable<String>.just(user.fullname)
    }
    
    var position: Observable<String> {
        return Observable<String>.just(user.position)
    }
    
    var picUrl: Observable<String> {
        return Observable<String>.just(user.picUrl)
    }
 }
