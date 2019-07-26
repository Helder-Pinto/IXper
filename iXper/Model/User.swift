//
//  User.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 24/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation


class User{
    
    private var fullName: String
    private var jobPosition: String
    private var photoUrl: String
    
    var fullname: String{
        return fullName
    }
    var position: String{
        
        return jobPosition
    }
    
    var picUrl: String {
        return photoUrl
    }
    
    init(fullname: String, position: String, picUrl: String){
        self.fullName = fullname
        self.jobPosition = position
        self.photoUrl = picUrl
    }
}
