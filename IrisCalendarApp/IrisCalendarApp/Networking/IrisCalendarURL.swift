//
//  IrisCalendarURL.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

enum IrisCalendarURL {
    case signIn, signUp
    case allocationTime
    case category
    case calendar, particularCalendar(calendarId: Int)

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
        case .particularCalendar(let id):
            return "/calendar/\(id)"
        }
    }
}
