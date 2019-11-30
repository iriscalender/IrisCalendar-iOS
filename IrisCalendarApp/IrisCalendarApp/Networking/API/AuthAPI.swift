//
//  AuthAPI.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 08/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class AuthAPI: AuthProvider {
    private let httpClient = HTTPClient()

    func postSignUp(userID: String, userPW: String, userRePW: String) -> Observable<NetworkingResult> {
        return httpClient.post(url: IrisCalendarURL.signUp.path(),
                               param: ["id": userID,
                                       "password1": userPW,
                                       "password2": userRePW],
                               header: Header.noToken.header())
            .map { (response, data) -> NetworkingResult in
                switch response.statusCode {
                case 201:
                    guard let data = try? JSONDecoder().decode(AuthModel.self, from: data) else { return .failure }
                    Token.token = data.token
                    return .created
                case 400: return .badRequest
                case 409: return .conflict
                case 500: return .serverError
                default: return .failure
                }
        }
    }

    func postSignIn(userID: String, userPW: String) -> Observable<NetworkingResult> {
        return httpClient.post(url: IrisCalendarURL.signIn.path(),
                               param: ["id": userID,
                                       "password": userPW],
                               header: Header.noToken.header())
            .map { (response, data) -> NetworkingResult in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(AuthModel.self, from: data) else { return .failure }
                    Token.token = data.token
                    return .ok
                case 400: return .badRequest
                case 500: return .serverError
                default: return .failure
                }
        }
    }
}
