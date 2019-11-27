//
//  HTTPClient.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift

class HTTPClient {
    typealias Parameters = [String: Any]
    typealias httpResult = Observable<(response: HTTPURLResponse, data: Data)>

    func get(url: String, param: Parameters?, header: [String: String]) -> httpResult {
        guard let url = URL(string: url) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        return URLSession.shared.rx.response(request: request)
    }

    func post(url: String, param: Parameters?, header: [String: String]) -> httpResult {
        guard let url = URL(string: url),
            let data = try? JSONSerialization.data(withJSONObject: param as Any, options: .prettyPrinted) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = "POST"
        request.httpBody = data
        return URLSession.shared.rx.response(request: request)
    }

    func patch(url: String, param: Parameters?, header: [String: String]) -> httpResult {
        guard let url = URL(string: url),
            let data = try? JSONSerialization.data(withJSONObject: param as Any, options: .prettyPrinted) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = "PATCH"
        request.httpBody = data
        return URLSession.shared.rx.response(request: request)
    }

    func delete(url: String, param: Parameters?, header: [String: String]) -> httpResult {
        guard let url = URL(string: url),
            let data = try? JSONSerialization.data(withJSONObject: param as Any, options: .prettyPrinted) else { return Observable.empty() }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = "DELETE"
        request.httpBody = data
        return URLSession.shared.rx.response(request: request)
    }

}

enum Header {
    case token, noToken

    func getHeader() -> [String: String] {
        switch self {
        case .token:
            guard let token = Token.token else { return [:] }
            return ["Content-Type": "application/json", "Authorization": token]
        case .noToken:
            return ["Content-Type": "application/json"]
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
