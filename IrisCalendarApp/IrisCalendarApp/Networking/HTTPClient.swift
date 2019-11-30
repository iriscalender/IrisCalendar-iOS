//
//  HTTPClient.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 07/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxAlamofire
import Alamofire

class HTTPClient {
    typealias HttpResult = Observable<(HTTPURLResponse, Data)>

    func get(url: String, param: Parameters?, header: [String: String]) -> HttpResult {
        return requestData(.get,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }

    func post(url: String, param: Parameters?, header: [String: String]) -> HttpResult {
        return requestData(.post,
                           url,
                           parameters: param,
                           encoding: JSONEncoding.prettyPrinted,
                           headers: header)
    }

    func patch(url: String, param: Parameters?, header: [String: String]) -> HttpResult {
        return requestData(.patch,
                           url,
                           parameters: param,
                           encoding: JSONEncoding.prettyPrinted,
                           headers: header)
    }

    func delete(url: String, param: Parameters?, header: [String: String]) -> HttpResult {
        return requestData(.delete,
                           url,
                           parameters: param,
                           encoding: URLEncoding.queryString,
                           headers: header)
    }
}

enum Header {
    case token, noToken

    func header() -> [String: String] {
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

    func toStringForSchedule(status: ScheduleStatus) -> String {
        switch self {
        case .ok, .created: return "성공"
        case .badRequest: return "유효하지 않은 요청"
        case .unauthorized: return "유효하지 않은 토큰"
        case .conflict: return "소화할 수 없는 일정"
        case .serverError: return "서버오류"
        default:
            switch status {
            case .add: return "일정 추가 실패"
            case .update: return "일정 수정 실패"
            case .unknown: return "알 수 없는 status"
            }
        }
    }
}
