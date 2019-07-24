//
//  User.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 24/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import Foundation


class User{
    
    private var _fullname: String
    private var _position: String
    
    var fullname: String{
        return _fullname
    }
    var position: String{
        
        return _position
    }
    
    init(fullname: String, position: String){
        self._fullname = fullname
        self._position = position
    }
}
