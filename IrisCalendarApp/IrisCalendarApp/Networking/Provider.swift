//
//  Provider.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

protocol IrisProvider {
    typealias NetworkingResultResponse = Observable<NetworkingResult>
}

protocol AuthProvider: IrisProvider {
    func postSignUp(userID: String, userPW: String, userRePW: String) -> NetworkingResultResponse
    func postSignIn(userID: String, userPW: String) -> NetworkingResultResponse
}

protocol AllocationTimeProvider: IrisProvider {
    func getAlloctionTime() -> Observable<(AllocationTimeModel?, NetworkingResult)>
    func setAlloctionTime(startTime: String, endTime: String) -> NetworkingResultResponse
    func updateAlloctionTime(startTime: String, endTime: String) -> NetworkingResultResponse
}

protocol CategoryProvider: IrisProvider {
    func getCategory() -> Observable<(CategoryModel?, NetworkingResult)>
    func updateCategory(_ category: CategoryModel) -> NetworkingResultResponse
}

protocol CalendarProvider: IrisProvider {
    func getAutoCalendar(_ calendarID: String) -> Observable<(IdAutoScheduleModel?, NetworkingResult)>
    func addAutoCalendar(_ calendar: AutoScheduleModel) -> NetworkingResultResponse
    func updateAutoCalendar(_ calendar: AutoScheduleModel, calendarID: String) -> NetworkingResultResponse
    func deleteAutoCalendar(_ calendarID: String) -> NetworkingResultResponse

    func getFixCalendar(_ calendarID: String) -> Observable<(IdFixScheduleModel?, NetworkingResult)>
    func addFixCalendar(_ calendar: FixScheduleModel) -> NetworkingResultResponse
    func updateFixCalendar(_ calendar: FixScheduleModel, calendarID: String) -> NetworkingResultResponse
    func deleteFixCalendar(_ calendarID: String) -> NetworkingResultResponse

    func getDailyCalendar(_ date: String) -> Observable<(DailyScheduleModel?, NetworkingResult)>
    func getBookedCalendar() -> Observable<(BookedScheduleModel?, NetworkingResult)>
}
