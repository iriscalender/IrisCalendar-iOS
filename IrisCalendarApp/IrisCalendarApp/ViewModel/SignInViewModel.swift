//
//  SignInViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/25.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SignInViewModel: ViewModelType {
    struct Input {
        let loginTaps: Signal<Void>
        let id: Driver<String>
        let pw: Driver<String>
    }

    struct Output {
        let result: Driver<String>
        let isEnabled: Driver<Bool>
    }

    func transform(input: SignInViewModel.Input) -> SignInViewModel.Output {
        let api = AuthAPI()
        let info = Driver.combineLatest(input.id, input.pw)

        let isEnabled = info.map { (id, pw) -> Bool in
            if id.count > 5 && pw.range(of: #"\b[A-Za-z0-9]{8,}\b"#, options: .regularExpression) != nil {
                return true
            }
            return false
        }.asDriver()

        let result = input.loginTaps.withLatestFrom(info).flatMap { (id, pw) -> Driver<String> in
            return api.postSignIn(id: id, pw: pw).map { (result) -> String in
                switch result {
                case .ok : return "성공"
                case .badRequest : return "유효하지 않은 요청"
                case .serverError : return "서버에러"
                default : return ""
                }
            }.asDriver(onErrorJustReturn: "")
        }

        return Output(result: result, isEnabled: isEnabled)
    }


}
