//
//  Iris.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/30.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation
import UIKit

struct IrisColor {
    static let main = UIColor().hexStringToUIColor(hex: "7247B2")
    static let mainHalfClear = UIColor().hexStringToUIColor(hex: "7247B2").withAlphaComponent(0.67)
    static let authTxtField = UIColor().hexStringToUIColor(hex: "A2D7E3")
    static let blueCategory = UIColor().hexStringToUIColor(hex: "3CB8EF")
    static let pinkCategory = UIColor().hexStringToUIColor(hex: "D92D73")
    static let orangeCategory = UIColor().hexStringToUIColor(hex: "FDA921")
    static let lightGray = UIColor().hexStringToUIColor(hex: "D5D5D5")
    static let defaultGray = UIColor().hexStringToUIColor(hex: "B4B4B4")
    static let btnIsUnableState = UIColor().hexStringToUIColor(hex: "F2F2F7")
    static let calendarTitle = UIColor().hexStringToUIColor(hex: "383535")
    static let calendarDefault = UIColor().hexStringToUIColor(hex: "747474")
    static let todayColor = UIColor().hexStringToUIColor(hex: "FAA86B")
}

struct IrisFilter {
    static func checkIDPW(userID: String, userPW: String) -> Bool {
        return userID.count > 5 && userPW.range(of: "[A-Za-z0-9]{8,}", options: .regularExpression) != nil
    }
}

enum IrisDateFormat: String {
    case time = "HH:mm"
    case date = "yyyy-MM-dd"
    case dateWithTime = "yyyy-MM-dd HH:mm"

    func toString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter.string(from: date)
    }

    func isStartFaster(startTime: String, endTime: String) -> Bool {
        if startTime == self.rawValue || endTime == self.rawValue { return false }
        return startTime.components(separatedBy: [":", "-"]).joined() < endTime.components(separatedBy: [":","-"]).joined()
    }
}
