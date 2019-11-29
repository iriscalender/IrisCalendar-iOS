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
    func postSignUp(userID: String, userPW: String, userRePW:String) -> Observable<NetworkingResult>
    func postSignIn(userID: String, userPW: String) -> Observable<NetworkingResult>
}

protocol AllocationTimeProvider{
    func getAlloctionTime() -> Observable<(AllocationTimeModel?, NetworkingResult)>
    func setAlloctionTime(startTime: String, endTime: String) -> Observable<(NetworkingResult)>
    func updateAlloctionTime(startTime: String, endTime: String) -> Observable<(NetworkingResult)>
}

protocol CategoryProvider {
    func getCategory() -> Observable<(CategoryModel?, NetworkingResult)>
    func updateCategory(_ category: CategoryModel) -> Observable<(CategoryModel?, NetworkingResult)>
}

protocol CalendarProvider {
    func getAutoCalendar(_ id: String) -> Observable<(IdAutoScheduleModel?, NetworkingResult)>
    func addAutoCalendar(_ calendar: AutoScheduleModel) -> Observable<(AutoScheduleModel?, NetworkingResult)>
    func updateAutoCalendar(_ calendar: AutoScheduleModel, id: String) -> Observable<(IdAutoScheduleModel?, NetworkingResult)>
    func deleteAutoCalendar(_ id: String) -> Observable<NetworkingResult>

    func getFixCalendar(_ id: String) -> Observable<(IdFixScheduleModel?, NetworkingResult)>
    func addFixCalendar(_ calendar: FixScheduleModel) -> Observable<(FixScheduleModel?, NetworkingResult)>
    func updateFixCalendar(_ calendar: FixScheduleModel, id: String) -> Observable<(IdFixScheduleModel?, NetworkingResult)>
    func deleteFixCalendar(_ id: String) -> Observable<NetworkingResult>

    func getDailyCalendar(_ date: String) -> Observable<(DailyScheduleModel?, NetworkingResult)>
    func getBookedCalendar() -> Observable<(BookedScheduleModel?, NetworkingResult)>
}
