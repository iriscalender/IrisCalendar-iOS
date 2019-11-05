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

    func getCategory() -> CategoryAPI.CategoryResult {
        return httpClient.patch(url: IrisCalendarURL.category.getPath(),
                                param: nil,
                                header: Header.token.getHeader())
            .map { (response) -> (CategoryModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(CategoryModel.self, from: response.1) else { return (nil, .failure) }
                switch response.0.statusCode {
                case 200: return (data, .ok)
                case 400: return (nil, .badRequest)
                case 401: return (nil, .unauthorized)
                case 500: return (nil, .serverError)
                default: return (nil, .failure)
                }
        }
    }

    func updateCategory(category: CategoryModel) -> CategoryAPI.CategoryResult {
        guard let param = category.asDictionary else { return Observable.just((nil, .failure)) }

        return httpClient.patch(url: IrisCalendarURL.category.getPath(),
                                param: param,
                                header: Header.token.getHeader())
            .map { (response) -> (CategoryModel?, NetworkingResult) in
                guard let data = try? JSONDecoder().decode(CategoryModel.self, from: response.1) else { return (nil, .failure) }
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
