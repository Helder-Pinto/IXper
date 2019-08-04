//
//  AuthViewModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 30/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class AuthViewModel {
    
    let currentUser = BehaviorRelay<Firebase.User?>(value: nil)
    
    init() {
        Auth.auth().addStateDidChangeListener { [currentUser] (auth, user) in
            currentUser.accept(user)
        }
    }
}
