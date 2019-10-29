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
    case calendar
    case addAutoCalendar
    case addManualCalendar
    case autoCalendar(calendarId: Int)
    case manualCalendar(calendarId: Int)

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
        case .calendar:
            return "/calendar"
        case .addAutoCalendar:
            return "/calendar/auto"
        case .addManualCalendar:
            return "/calendar/manual"
        case .autoCalendar(let id):
            return "/calendar/auto/\(id)"
        case .manualCalendar(let id):
            return "/calendar/manual/\(id)"
        }
    }
}
