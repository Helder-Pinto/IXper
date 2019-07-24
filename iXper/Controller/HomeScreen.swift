//
//  FirstViewController.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 21/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit
import Firebase

class HomeScreen: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var elapsedTime: UILabel!
   
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var actualTime: UILabel!
    
    @IBOutlet weak var todaysData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        DataService.instance.getUserData(forUid: Auth.auth().currentUser!.uid) { (user) in
            self.userName.text = user.fullname
            self.positionLabel.text = user.position
            
        }
        
    }
    
  

    @IBAction func logOutBtn(_ sender: Any) {
    }
    
    @IBAction func clockIn(_ sender: Any) {
    }
    
    
 
    @IBAction func clockOut(_ sender: Any) {
        
    }
}

