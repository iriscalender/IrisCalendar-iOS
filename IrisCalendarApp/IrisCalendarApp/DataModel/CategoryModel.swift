//
//  CategoryModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation
import UIKit

struct CategoryModel: Codable {
    let purple: String
    let blue: String
    let pink: String
    let orange: String
}

enum IrisCategory: String {
    case purple, blue, pink, orange

    static func getIrisCategory(category: String) -> IrisCategory {
        switch category {
        case "purple": return .purple
        case "blue": return .blue
        case "pink": return .pink
        case "orange": return .orange
        default: return .purple
        }
    }

    func getColor() -> UIColor {
        switch self {
        case .purple: return UIColor().hexStringToUIColor(hex: "#7247B2")
        case .blue: return UIColor().hexStringToUIColor(hex: "#3CB8EF")
        case .pink: return UIColor().hexStringToUIColor(hex: "#D92D73")
        case .orange: return UIColor().hexStringToUIColor(hex: "#FDA921")
        }
    }
}
