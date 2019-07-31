//
//  AuthVc.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 22/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

import GoogleSignIn

class AuthViewController: UIViewController, GIDSignInUIDelegate {
    
    let disposeBag = DisposeBag()
    lazy var viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        viewModel.currentUser
            .distinctUntilChanged()
            .subscribe(onNext: { user in
                if user != nil {
                    self.performSegue(withIdentifier: "homeScreen", sender: nil)
                } else {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func emailSignInBtn(_ sender: Any) {
        let emailVc = storyboard?.instantiateViewController(withIdentifier: "EmailVc")
        present(emailVc!, animated: true, completion: nil)
    }
    
    
    
    
    
}
