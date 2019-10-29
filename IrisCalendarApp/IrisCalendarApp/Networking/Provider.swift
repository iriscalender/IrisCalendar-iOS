//
//  Provider.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

protocol AuthProvider {
    func postSignUp(id: String, pw: String, rePW:String) -> Observable<NetworkingResult>
    func postSignIn(id: String, pw: String) -> Observable<NetworkingResult>
}

protocol AllocationTimeProvider{
    typealias AllocationTimeResult = Observable<(AllocationTimeModel?, NetworkingResult)>

    func getAlloctionTime() -> AllocationTimeResult
    func setAlloctionTime(startTime: String, endTime: String) -> AllocationTimeResult
    func updateAlloctionTime(startTime: String, endTime: String) -> AllocationTimeResult
}

protocol CategoryProvider {
    typealias CategoryResult = Observable<(CategoryModel?, NetworkingResult)>

    func getCategory() -> CategoryResult
    func updateCategory(category: CategoryModel) -> CategoryResult
}

protocol CalendarProvider {
    func getTheEntireCalendar() -> Observable<(TheEntireCalendarModel?, NetworkingResult)>
    func addCalendar(calendar: NoIdCalendarModel) -> Observable<(NoIdCalendarModel?, NetworkingResult)>
    func getCalendar(calendarId: Int) -> Observable<(CalendarModel?, NetworkingResult)>
    func updateCalendar(calendarId: Int, calendar: NoIdCalendarModel) -> Observable<(CalendarModel?, NetworkingResult)>
}
