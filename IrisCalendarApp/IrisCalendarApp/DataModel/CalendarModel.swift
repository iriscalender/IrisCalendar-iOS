//
//  CalendarModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

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

struct IdAutoScheduleModel: Codable {
    let calendarID: String
    let category: String
    let scheduleName: String
    let endTime: String
    let requiredTime: Int
    let isParticularImportant: Bool

    enum CodingKeys: String, CodingKey {
        case calendarID = "id"
        case category
        case scheduleName = "calendarName"
        case endTime
        case requiredTime
        case isParticularImportant
    }
}

struct IdFixScheduleModel: Codable {
    let calendarID: String
    let category: String
    let scheduleName: String
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case calendarID = "id"
        case category
        case scheduleName = "calendarName"
        case startTime
        case endTime
    }
}

struct BookedSchedule: Codable {
    let category: String
    let date: String
}

struct BookedScheduleModel: Codable {
    let schedules: [BookedSchedule]

    enum CodingKeys: String, CodingKey {
        case schedules = "calendar"
    }
}

struct DailyScheduleModel: Codable {
    let fixSchedules: [IdFixScheduleModel]
    let autoSchedules: [IdFixScheduleModel]

    enum CodingKeys: String, CodingKey {
        case fixSchedules = "manual"
        case autoSchedules = "auto"
    }
}

struct DailySchedule {
    let calendarID: String
    let category: IrisCategory.Category
    let scheduleName: String
    let startTime: String
    let endTime: String
    let isAuto: Bool
}

enum ScheduleStatus {
    case add
    case update(calendarId: String)
    case unknown
}
