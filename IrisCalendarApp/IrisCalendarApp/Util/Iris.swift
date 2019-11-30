//
//  Iris.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/30.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

enum IrisDateFormat: String {
    case time = "HH:mm"
    case date = "yyyy-MM-dd"
    case dateAndTime = "yyyy-MM-dd HH:mm"

    func toString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter.string(from: date)
    }

    func isStartFaster(startTime: String, endTime: String) -> Bool {
        if startTime == self.rawValue || endTime == self.rawValue { return false }
        return startTime.components(separatedBy: [":", "-"]).joined() < endTime.components(separatedBy: [":", "-"]).joined()
    }
}

struct IrisColor {
    static let main = UIColor().hexStringToUIColor(hex: "7247B2")
    static let mainHalfClear = UIColor().hexStringToUIColor(hex: "7247B2").withAlphaComponent(0.67)
    static let authTxtField = UIColor().hexStringToUIColor(hex: "A2D7E3")
    static let authTxtFieldEnable = UIColor().hexStringToUIColor(hex: "3CB8EF")
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

class IrisCategory {
    static let shared = IrisCategory()
    private let disposeBag = DisposeBag()

    var purple = "기타"
    var blue = "회의, 미팅"
    var pink = "운동"
    var orange = "과제, 공부"

    private init() {
        CategoryAPI().getCategory().subscribe(onNext: { [weak self] (response, _) in
            guard let response = response, let self = self else { return }
            self.purple = response.purple
            self.blue = response.blue
            self.pink = response.pink
            self.orange = response.orange
        }).disposed(by: disposeBag)
    }

    enum Category: String {
        case purple, blue, pink, orange

        static func toCategory(category: String) -> Category {
            switch category {
            case "purple": return .purple
            case "blue": return .blue
            case "pink": return .pink
            case "orange": return .orange
            default: return .purple
            }
        }

        func toColor() -> UIColor {
            switch self {
            case .purple: return UIColor().hexStringToUIColor(hex: "7247B2")
            case .blue: return UIColor().hexStringToUIColor(hex: "3CB8EF")
            case .pink: return UIColor().hexStringToUIColor(hex: "D92D73")
            case .orange: return UIColor().hexStringToUIColor(hex: "FDA921")
            }
        }
    }
}
