//
//  ShadowView.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 24/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    override func prepareForInterfaceBuilder() {
        shadow()
    }
    override func awakeFromNib() {
        shadow()
        super.awakeFromNib()
    }
    
    
    func shadow(){
        layer.shadowOpacity = 0.5
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowRadius = 3
        layer.cornerRadius = 5

    }
    
}
