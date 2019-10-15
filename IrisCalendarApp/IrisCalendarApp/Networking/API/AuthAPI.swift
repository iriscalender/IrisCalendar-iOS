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

    func postSignUp(id: String, pw: String, rePW: String) -> Observable<NetworkingResult> {
        let param = [ "id": id, "password1": pw, "password2": rePW ]

        return httpClient.post(url: IrisCalendarURL.signUp.getPath(), param: param, header: Header.noToken.getHeader())
            .map { (response) -> NetworkingResult in
                guard let data = try? JSONDecoder().decode(AuthModel.self, from: response.1) else { return .failure }

                switch response.0.statusCode {
                case 201:
                    Token.token = data.token
                    return .created
                case 400: return .badRequest
                case 409: return .conflict
                case 500: return .serverError
                default: return .failure
                }
            }
    }

    func postSignIn(id: String, pw: String) -> Observable<NetworkingResult> {
        let param = [ "id": id, "password": pw ]

        return httpClient.post(url: IrisCalendarURL.signIn.getPath(), param: param, header: Header.noToken.getHeader())
            .map { (response) -> NetworkingResult in
                guard let data = try? JSONDecoder().decode(AuthModel.self, from: response.1) else { return .failure }

                switch response.0.statusCode {
                case 200:
                    Token.token = data.token
                    return .created
                case 400: return .badRequest
                case 500: return .serverError
                default: return .failure
                }
            }
    }
}
