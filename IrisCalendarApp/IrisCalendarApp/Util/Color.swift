//
//  Color.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 03/09/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

struct Color {
    static let main: UIColor = UIColor(hex: "#7247B2") ?? UIColor.gray
    static let mainHalfClear: UIColor = UIColor(hex: "#7247B2")?.withAlphaComponent(0.67) ?? UIColor.gray
    static let authTextfield: UIColor = UIColor(hex: "#A2D7E3") ?? UIColor.gray
    static let skyblueCategory: UIColor = UIColor(hex: "#3CB8EF") ?? UIColor.gray
    static let pinkCategory: UIColor = UIColor(hex: "#D92D73") ?? UIColor.gray
    static let yelloCategory: UIColor = UIColor(hex: "#FDA921") ?? UIColor.gray
    static let lightGray: UIColor = UIColor(hex: "#D5D5D5") ?? UIColor.gray
    static let defaultGray: UIColor = UIColor(hex: "#B4B4B4") ?? UIColor.gray
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
