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
    func updateCategory(_ category: CategoryModel) -> CategoryResult
}

protocol CalendarProvider {
    typealias AutoCalendarResult = Observable<(AutoScheduleModel?, NetworkingResult)>
    typealias FixCalendarResult = Observable<(FixScheduleModel?, NetworkingResult)>
    typealias IdAutoCalendarResult = Observable<(IdAutoScheduleModel?, NetworkingResult)>
    typealias IdFixCalendarResult = Observable<(IdFixScheduleModel?, NetworkingResult)>

    func getAutoCalendar(_ id: String) -> IdAutoCalendarResult
    func addAutoCalendar(_ calendar: AutoScheduleModel) -> AutoCalendarResult
    func updateAutoCalendar(_ calendar: AutoScheduleModel, id: String) -> IdAutoCalendarResult
    func deleteAutoCalendar(_ id: String) -> Observable<NetworkingResult>

    func getFixCalendar(_ id: String) -> IdFixCalendarResult
    func addFixCalendar(_ calendar: FixScheduleModel) -> FixCalendarResult
    func updateFixCalendar(_ calendar: FixScheduleModel, id: String) -> IdFixCalendarResult
    func deleteFixCalendar(_ id: String) -> Observable<NetworkingResult>

    func getDailyCalendar(_ date: String) -> Observable<(DailyScheduleModel?, NetworkingResult)>
    func getBookedCalendar() -> Observable<(BookedScheduleModel?, NetworkingResult)>
}
