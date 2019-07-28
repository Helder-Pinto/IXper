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
 
 
 class HomeViewModel {
    
    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void){
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion (image)
                        
                    }
                }
            }
        }
    }
    
    
    
 }
 
