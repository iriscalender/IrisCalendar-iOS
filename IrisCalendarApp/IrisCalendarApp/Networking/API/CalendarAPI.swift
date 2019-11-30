//
//  CalendarAPI.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/06.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class CalendarAPI: CalendarProvider {
    private let httpClient = HTTPClient()

    func getAutoCalendar(_ calendarID: String) -> Observable<(IdAutoScheduleModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.autoCalendar(calendarId: calendarID).path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response, data) -> (IdAutoScheduleModel?, NetworkingResult) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(IdAutoScheduleModel.self, from: data) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func addAutoCalendar(_ calendar: AutoScheduleModel) -> Observable<NetworkingResult> {
        guard let param = calendar.asDictionary else { return Observable.just(.failure) }

        return httpClient.post(url: IrisCalendarURL.addAutoCalendar.path(),
                               param: param,
                               header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 400: return .badRequest
                case 401: return .unauthorized
                case 409: return .conflict
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func updateAutoCalendar(_ calendar: AutoScheduleModel, calendarID: String) -> Observable<NetworkingResult> {
        guard let param = calendar.asDictionary else { return Observable.just(.failure) }

        return httpClient.patch(url: IrisCalendarURL.autoCalendar(calendarId: calendarID).path(),
                                param: param,
                                header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 400: return .badRequest
                case 401: return .unauthorized
                case 409: return .conflict
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func deleteAutoCalendar(_ calendarID: String) -> Observable<NetworkingResult> {
        return httpClient.delete(url: IrisCalendarURL.autoCalendar(calendarId: calendarID).path(),
                                 param: nil,
                                 header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 204: return .noContent
                case 401: return .unauthorized
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func getFixCalendar(_ calendarID: String) -> Observable<(IdFixScheduleModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.fixCalendar(calendarId: calendarID).path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response, data) -> (IdFixScheduleModel?, NetworkingResult) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(IdFixScheduleModel.self, from: data) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func addFixCalendar(_ calendar: FixScheduleModel) -> Observable<NetworkingResult> {
        guard let param = calendar.asDictionary else { return Observable.just(.failure) }

        return httpClient.post(url: IrisCalendarURL.addFixCalendar.path(),
                               param: param,
                               header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 201: return .created
                case 400: return .badRequest
                case 401: return .unauthorized
                case 409: return .conflict
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func updateFixCalendar(_ calendar: FixScheduleModel, calendarID: String) -> Observable<NetworkingResult> {
        guard let param = calendar.asDictionary else { return Observable.just(.failure) }

        return httpClient.patch(url: IrisCalendarURL.fixCalendar(calendarId: calendarID).path(),
                                param: param,
                                header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 400: return .badRequest
                case 401: return .unauthorized
                case 409: return .conflict
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func deleteFixCalendar(_ calendarID: String) -> Observable<NetworkingResult> {
        return httpClient.delete(url: IrisCalendarURL.autoCalendar(calendarId: calendarID).path(),
                                 param: nil,
                                 header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 204: return .noContent
                case 401: return .unauthorized
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func getDailyCalendar(_ date: String) -> Observable<(DailyScheduleModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.dailyCalendar(date: date).path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response, data) -> (DailyScheduleModel?, NetworkingResult) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(DailyScheduleModel.self, from: data) else { return (nil, .failure) }
                    return (data, .ok)
                case 204: return (nil, .noContent)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func getBookedCalendar() -> Observable<(BookedScheduleModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.bookedCalendar.path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response, data) -> (BookedScheduleModel?, NetworkingResult) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(BookedScheduleModel.self, from: data) else { return (nil, .failure) }
                    return (data, .ok)
                case 204: return (nil, .noContent)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }
}
