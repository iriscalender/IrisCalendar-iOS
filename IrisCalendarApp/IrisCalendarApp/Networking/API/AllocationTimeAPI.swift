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

    func getAlloctionTime() -> AllocationTimeAPI.AllocationTimeResult {
        return httpClient.get(url: IrisCalendarURL.allocationTime.getPath(),
                              param: nil,
                              header: Header.token.getHeader())
            .map { (response) -> (AllocationTimeModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(AllocationTimeModel.self, from: response.1) else { return (nil, .failure) }
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

    func setAlloctionTime(startTime: String, endTime: String) -> AllocationTimeAPI.AllocationTimeResult {
        let param = ["start": startTime, "end": endTime]

        return httpClient.post(url: IrisCalendarURL.allocationTime.getPath(),
                               param: param,
                               header: Header.token.getHeader())
            .map { (response) -> (AllocationTimeModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(AllocationTimeModel.self, from: response.1) else { return (nil, .failure) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func updateAlloctionTime(startTime: String, endTime: String) -> AllocationTimeAPI.AllocationTimeResult {
        let param = ["start": startTime, "end": endTime]

        return httpClient.patch(url: IrisCalendarURL.allocationTime.getPath(),
                               param: param,
                               header: Header.token.getHeader())
            .map { (response) -> (AllocationTimeModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(AllocationTimeModel.self, from: response.1) else { return (nil, .failure) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }
}
