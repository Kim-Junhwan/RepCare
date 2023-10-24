//
//  Color.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/29.
//

import UIKit

enum Color {
    static let deepGreen = UIColor(named: "DeepGreen")
    static let lightDeepGreen = UIColor(named: "LightDeepGreen")
    static let lightGreen = UIColor(named: "LightGreen")
    static let brightLightGreen = UIColor(named: "BrightLightGreen")
    static let lightPink = UIColor(named: "LightPink")
    static let middleGray = UIColor(named: "MiddleGray")
    static let lightYellow = UIColor(named: "LightYellow")
    static let oceanBlue = UIColor(named: "OceanBlue")
    static let opacityGreen = UIColor(named: "OpacityGreen")
}

extension UIColor {
    func adjustBrightness(factor: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        red = min(1.0, red * factor)
        green = min(1.0, green * factor)
        blue = min(1.0, blue * factor)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
