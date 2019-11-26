//
//  Color.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 03/09/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

struct Color {
    static let main = UIColor().hexStringToUIColor(hex: "#7247B2")
    static let mainHalfClear = UIColor().hexStringToUIColor(hex: "#7247B2").withAlphaComponent(0.67)
    static let authTxtField = UIColor().hexStringToUIColor(hex: "#A2D7E3")
    static let blueCategory = UIColor().hexStringToUIColor(hex: "#3CB8EF")
    static let pinkCategory = UIColor().hexStringToUIColor(hex: "#D92D73")
    static let orangeCategory = UIColor().hexStringToUIColor(hex: "#FDA921")
    static let lightGray = UIColor().hexStringToUIColor(hex: "#D5D5D5")
    static let defaultGray = UIColor().hexStringToUIColor(hex: "#B4B4B4")
    static let btnIsEnableState = UIColor().hexStringToUIColor(hex: "F2F2F7")
    static let calendarTitle = UIColor().hexStringToUIColor(hex: "#383535")
    static let calendarDefault = UIColor().hexStringToUIColor(hex: "#747474")
}

extension UIColor {
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
