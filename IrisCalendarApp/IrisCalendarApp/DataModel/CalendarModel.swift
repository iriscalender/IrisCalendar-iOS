//
//  CalendarModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct TheEntireCalendarModel: Codable {
    let calendar: [CalendarModel]
}

struct CalendarModel: Codable {
    let id: Int
    let isAutomatic: Bool
    let category: String
    let calendarName: String
    let endTime: String
    let requiredTime: Int
    let isParticularImportant: Bool
}

struct NoIdCalendarModel: Codable {
    let isAutomatic: Bool
    let category: String
    let calendarName: String
    let endTime: String
    let requiredTime: Int
    let isParticularImportant: Bool
}
