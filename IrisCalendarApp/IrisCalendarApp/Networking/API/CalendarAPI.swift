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

    func getAutoCalendar(_ id: String) -> Observable<(IdAutoScheduleModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.autoCalendar(calendarId: id).path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response) -> (IdAutoScheduleModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(IdAutoScheduleModel.self, from: response.1) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func addAutoCalendar(_ calendar: AutoScheduleModel) -> Observable<(AutoScheduleModel?, NetworkingResult)> {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.post(url: IrisCalendarURL.addAutoCalendar.path(),
                               param: param,
                               header: Header.token.header())
            .map { (response) -> (AutoScheduleModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(AutoScheduleModel.self, from: response.1) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 409: return (nil, .conflict)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func updateAutoCalendar(_ calendar: AutoScheduleModel, id: String) -> Observable<(IdAutoScheduleModel?, NetworkingResult)> {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.patch(url: IrisCalendarURL.autoCalendar(calendarId: id).path(),
                                param: param,
                                header: Header.token.header())
            .map { (response) -> (IdAutoScheduleModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(IdAutoScheduleModel.self, from: response.1) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 409: return (nil, .conflict)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func deleteAutoCalendar(_ id: String) -> Observable<NetworkingResult> {
        return httpClient.delete(url: IrisCalendarURL.autoCalendar(calendarId: id).path(),
                                param: nil,
                                header: Header.token.header())
            .map { (response) -> NetworkingResult in
                switch response.0.statusCode {
                case 200: return .ok
                case 204: return .noContent
                case 401: return .unauthorized
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func getFixCalendar(_ id: String) -> Observable<(IdFixScheduleModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.fixCalendar(calendarId: id).path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response) -> (IdFixScheduleModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(IdFixScheduleModel.self, from: response.1) else { return (nil, .failure) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func addFixCalendar(_ calendar: FixScheduleModel) -> Observable<(FixScheduleModel?, NetworkingResult)> {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.post(url: IrisCalendarURL.addFixCalendar.path(),
                               param: param,
                               header: Header.token.header())
            .map { (response) -> (FixScheduleModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(FixScheduleModel.self, from: response.1) else { return ((nil, .failure)) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 409: return (nil, .conflict)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func updateFixCalendar(_ calendar: FixScheduleModel, id: String) -> Observable<(IdFixScheduleModel?, NetworkingResult)> {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.patch(url: IrisCalendarURL.fixCalendar(calendarId: id).path(),
                                param: param,
                                header: Header.token.header())
            .map { (response) -> (IdFixScheduleModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(IdFixScheduleModel.self, from: response.1) else { return ((nil, .failure)) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 409: return (nil, .conflict)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func deleteFixCalendar(_ id: String) -> Observable<NetworkingResult> {
        return httpClient.delete(url: IrisCalendarURL.autoCalendar(calendarId: id).path(),
                                param: nil,
                                header: Header.token.header())
            .map { (response) -> NetworkingResult in
                switch response.0.statusCode {
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
            .map { (response) -> (DailyScheduleModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(DailyScheduleModel.self, from: response.1) else { return ((nil, .failure)) }
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
            .map { (response) -> (BookedScheduleModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(BookedScheduleModel.self, from: response.1) else { return ((nil, .failure)) }
                    return (data, .ok)
                case 204: return (nil, .noContent)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }
}
