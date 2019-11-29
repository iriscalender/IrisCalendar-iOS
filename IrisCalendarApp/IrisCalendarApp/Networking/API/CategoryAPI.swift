//
//  CategoryAPI.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/05.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class CategoryAPI: CategoryProvider {

    private let httpClient = HTTPClient()

    func getCategory() -> Observable<(CategoryModel?, NetworkingResult)> {
        return httpClient.patch(url: IrisCalendarURL.category.path(),
                                param: nil,
                                header: Header.token.header())
            .map { (response) -> (CategoryModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(CategoryModel.self, from: response.1) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func updateCategory(_ category: CategoryModel) -> Observable<(CategoryModel?, NetworkingResult)> {
        guard let param = category.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.patch(url: IrisCalendarURL.category.path(),
                                param: param,
                                header: Header.token.header())
            .map { (response) -> (CategoryModel?, NetworkingResult) in
                switch response.0.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(CategoryModel.self, from: response.1) else { return (nil, .failure) }
                    return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }
}
