//
//  IrisCalendarURL.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

enum IrisCalendarURL {
    case signIn
    case signUp
    case allocationTime
    case category
    case dailyCalendar(date: String)
    case bookedCalendar
    case addAutoCalendar
    case addFixCalendar
    case autoCalendar(calendarId: Int)
    case fixCalendar(calendarId: Int)

    func getPath() -> String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/signup"
        case .allocationTime:
            return "/time"
        case .category:
            return "/category"
        case .dailyCalendar(let date):
            return "/calendar/\(date)"
        case .bookedCalendar:
            return "/calendar/book"
        case .addAutoCalendar:
            return "/calendar/auto"
        case .addFixCalendar:
            return "/calendar/manual/"
        case .autoCalendar(let id):
            return "/calendar/auto/\(id)"
        case .fixCalendar(let id):
            return "/calendar/manual/\(id)"
        }
    }
}
