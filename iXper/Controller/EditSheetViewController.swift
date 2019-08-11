//
//  EditTimeSheetViewController.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 11/08/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

class EditSheetViewController: UIViewController {
    
    @IBOutlet weak var clockIn: UITextField!
    @IBOutlet weak var clockOut: UITextField!
    @IBOutlet weak var clearButton: ShadowButton!
    @IBOutlet weak var saveButton: ShadowButton!
    
    var sheetData = [workDaysData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        clockIn.text = sheetData[0].clocktIn
        clockOut.text = sheetData[0].clockOut
    
        
    }
    

   
}
