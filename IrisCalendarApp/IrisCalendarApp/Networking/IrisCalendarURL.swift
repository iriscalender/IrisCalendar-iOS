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
    case autoCalendar(calendarId: String)
    case fixCalendar(calendarId: String)

    func getPath() -> String {
        let baseURL = "http://iriscalendar.ap-northeast-2.elasticbeanstalk.com"
        switch self {
        case .signIn:
            return baseURL + "/auth/signin"
        case .signUp:
            return baseURL + "/auth/signup"
        case .allocationTime:
            return baseURL + "/time"
        case .category:
            return baseURL + "/category"
        case .dailyCalendar(let date):
            return baseURL + "/calendar/\(date)"
        case .bookedCalendar:
            return baseURL + "/calendar/book"
        case .addAutoCalendar:
            return baseURL + "/calendar/auto"
        case .addFixCalendar:
            return baseURL + "/calendar/manual/"
        case .autoCalendar(let id):
            return baseURL + "/calendar/auto/\(id)"
        case .fixCalendar(let id):
            return baseURL + "/calendar/manual/\(id)"
        }
    }
}
