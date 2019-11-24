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

class CalendarAPI: CalendarProvider{

    private let httpClient = HTTPClient()

    func getAutoCalendar(_ id: Int) -> CalendarAPI.AutoCalendarResult {
        return httpClient.get(url: IrisCalendarURL.autoCalendar(calendarId: id).getPath(),
                              param: nil,
                              header: Header.token.getHeader())
            .map { (response) -> (AutoScheduleModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(AutoScheduleModel.self, from: response.1) else { return (nil, .failure) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func addAutoCalendar(_ calendar: AutoScheduleModel) -> CalendarAPI.AutoCalendarResult {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.post(url: IrisCalendarURL.addAutoCalendar.getPath(),
                               param: param,
                               header: Header.token.getHeader())
            .map { (response) -> (AutoScheduleModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(AutoScheduleModel.self, from: response.1) else { return (nil, .failure) }
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

    func updateAutoCalendar(_ calendar: AutoScheduleModel, id: Int) -> CalendarAPI.AutoCalendarResult {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.patch(url: IrisCalendarURL.autoCalendar(calendarId: id).getPath(),
                                param: param,
                                header: Header.token.getHeader())
            .map { (response) -> (AutoScheduleModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(AutoScheduleModel.self, from: response.1) else { return ((nil, .failure)) }
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

    func getFixCalendar(_ id: Int) -> CalendarAPI.FixCalendarResult {
        return httpClient.get(url: IrisCalendarURL.fixCalendar(calendarId: id).getPath(),
                              param: nil,
                              header: Header.token.getHeader())
            .map { (response) -> (FixScheduleModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(FixScheduleModel.self, from: response.1) else { return (nil, .failure) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func addFixCalendar(_ calendar: FixScheduleModel) -> CalendarAPI.FixCalendarResult {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.post(url: IrisCalendarURL.addFixCalendar.getPath(),
                                param: param,
                                header: Header.token.getHeader())
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

    func updateFixCalendar(_ calendar: FixScheduleModel, id: Int) -> CalendarAPI.FixCalendarResult {
        guard let param = calendar.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.patch(url: IrisCalendarURL.fixCalendar(calendarId: id).getPath(),
                                param: param,
                                header: Header.token.getHeader())
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

    func getDailyCalendar(_ date: String) -> Observable<([DailyCalendarModel]?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.dailyCalendar(date: date).getPath(),
                                param: nil,
                                header: Header.token.getHeader())
            .map { (response) -> ([DailyCalendarModel]?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode([DailyCalendarModel].self, from: response.1) else { return ((nil, .failure)) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 204: return (nil, .noContent)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func getBookedCalendar() -> Observable<([BookedCalendarModel]?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.bookedCalendar.getPath(),
                                param: nil,
                                header: Header.token.getHeader())
            .map { (response) -> ([BookedCalendarModel]?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode([BookedCalendarModel].self, from: response.1) else { return ((nil, .failure)) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 204: return (nil, .noContent)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }
}
