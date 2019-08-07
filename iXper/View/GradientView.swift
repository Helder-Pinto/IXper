//
//  gradientView.swift
//  iXper
//
//  Created by Afonso Pinto, Helder Manuel on 22/07/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

@IBDesignable
class gradientView: UIView {


    
    override func prepareForInterfaceBuilder() {
        gradient()
    }
    
    override func awakeFromNib() {
        gradient()
        super.awakeFromNib()
    }
    
    func gradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = layer.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        layer.addSublayer(gradientLayer)
    }

}
