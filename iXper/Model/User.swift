//
//  User.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 24/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//


import UIKit

class User{
    
    public private(set) var fullname: String
    public private(set) var position: String
    public private(set) var picUrl: String
   
    
    
    init(fullname: String, position: String, picUrl: String){
        self.fullname = fullname
        self.position = position
        self.picUrl = picUrl
    }
}
