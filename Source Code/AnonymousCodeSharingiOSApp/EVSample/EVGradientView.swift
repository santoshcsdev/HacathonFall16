//
//  EVGradientView.swift
//  EyeprintID
//
//  Created by goodle on 8/3/15.
//  Copyright (c) 2015 EyeVerify. All rights reserved.
//

import UIKit

@IBDesignable
class EVGradientView: UIView {

    let gradientLayer = CAGradientLayer()
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = rect
        let caribbeanGreen = UIColor(red: 0.125, green: 0.765, blue: 0.616, alpha: 1.000).cgColor as CGColor
        let lightSeaGreen = UIColor(red: 0.161, green: 0.671, blue: 0.698, alpha: 1.000).cgColor as CGColor
        gradientLayer.colors = [caribbeanGreen, lightSeaGreen]
        //        self.view.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
