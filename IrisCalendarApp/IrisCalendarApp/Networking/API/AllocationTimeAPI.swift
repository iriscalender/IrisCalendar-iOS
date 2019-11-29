//
//  AllocationTimeAPI.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class AllocationTimeAPI: AllocationTimeProvider {
    private let httpClient = HTTPClient()

    func getAlloctionTime() -> Observable<(AllocationTimeModel?, NetworkingResult)> {
        return httpClient.get(url: IrisCalendarURL.allocationTime.path(),
                              param: nil,
                              header: Header.token.header())
            .map { (response, data) -> (AllocationTimeModel?, NetworkingResult) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(AllocationTimeModel.self, from: data) else { return (nil, .failure) }
                    return (data, .ok)
                case 204: return (nil, .noContent)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func setAlloctionTime(startTime: String, endTime: String) -> Observable<NetworkingResult> {
        return httpClient.post(url: IrisCalendarURL.allocationTime.path(),
                               param: ["start": startTime,
                                       "end": endTime],
                               header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 400: return .badRequest
                case 401: return .unauthorized
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func updateAlloctionTime(startTime: String, endTime: String) -> Observable<NetworkingResult> {
        return httpClient.patch(url: IrisCalendarURL.allocationTime.path(),
                                param: ["start": startTime,
                                        "end": endTime],
                                header: Header.token.header())
            .map { (response, _) -> NetworkingResult in
                switch response.statusCode {
                case 200: return .ok
                case 400: return .badRequest
                case 401: return .unauthorized
                case 500: return .serverError
                default: return .failure
                }
        }
    }
}
