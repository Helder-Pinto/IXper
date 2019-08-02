//
//  DataSheetModel.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 02/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

struct workTimeCapture {
    
    
    var clockIn: String
    var clockOut: String
    var pause: String
    
    var workingHours: Int{
        
        return Int(clockOut)! - Int(clockIn)! - Int(pause)!
    }
    
}
