//
//  HTTPClient.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxAlamofire
import Alamofire
import RxSwift

class HTTPClient {
    typealias param = [String: Any]

    func get(url: String, param: param?, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.get,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }

    func post(url: String, param: param?, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.post,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }

    func patch(url: String, param: param?, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.patch,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }

    func delete(url: String, param: param?, header: [String: String]) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.delete,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }

}

enum Header {
    case token, noToken

    func getHeader() -> [String: String] {
        switch self {
        case .token:
            guard let token = Token.token else { return [:] }
            return ["content-type": "application/json", "Authorization": token]
        case .noToken:
            return ["content-type": "application/json"]
        }
    }
}

struct Token {
    static var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "Token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Token")
        }
    }
}
                 
enum NetworkingResult: Int {
    case failure = 0
    case ok = 200
    case created = 201
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case conflict = 409
    case serverError = 500
}
