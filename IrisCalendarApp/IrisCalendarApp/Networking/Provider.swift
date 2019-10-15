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
    func getAlloctionTime() -> Observable<(AllocationTimeModel?, NetworkingResult)>
    func setAlloctionTime(startTime: String, endTime: String) -> Observable<(AllocationTimeModel?, NetworkingResult)>
    func updateAlloctionTime(startTime: String, endTime: String) -> Observable<(AllocationTimeModel?, NetworkingResult)>
}

protocol CategoryProvider {
    func getCategory() -> Observable<(CategoryModel?, NetworkingResult)>
    func updateCategory(category: CategoryModel) -> Observable<(CategoryModel?, NetworkingResult)>
}

protocol CalendarProvider {
    func getTheEntireCalendar() -> Observable<(TheEntireCalendarModel?, NetworkingResult)>
    func addCalendar(calendar: NoIdCalendarModel) -> Observable<(NoIdCalendarModel?, NetworkingResult)>
    func getCalendar(calendarId: Int) -> Observable<(CalendarModel?, NetworkingResult)>
    func updateCalendar(calendarId: Int, calendar: NoIdCalendarModel) -> Observable<(CalendarModel?, NetworkingResult)>
}
