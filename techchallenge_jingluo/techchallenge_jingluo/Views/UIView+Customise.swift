//
//  UIView+Customise.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 27/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func insertThemeColorLayer(_ colors: (UIColor, UIColor)) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            colors.0.cgColor,
            colors.1.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        if let first = self.layer.sublayers?.first {
            first.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
