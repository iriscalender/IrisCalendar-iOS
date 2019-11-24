//
//  CalendarModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct DailyCalendarModel: Codable {
    let id: Int
    let category: String
    let scheduleName: String
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case scheduleName = "calendarName"
        case startTime
        case endTime
    }
}

struct AutoScheduleModel: Codable {
    let category: String
    let scheduleName: String
    let endTime: String
    let requiredTime: Int
    let isParticularImportant: Bool

    enum CodingKeys: String, CodingKey {
        case category
        case scheduleName = "calendarName"
        case endTime
        case requiredTime
        case isParticularImportant
    }
}

struct FixScheduleModel: Codable {
    let category: String
    let scheduleName: String
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case category
        case scheduleName = "calendarName"
        case startTime
        case endTime
    }
}

struct BookedCalendarModel: Codable {
    let category: String
    let date: String
}

enum ScheduleStatus {
    case add
    case update(calendarId: Int)
    case unknown
}
