//
//  SignUpViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 08/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {

    struct Input {
        let signUpTaps: Signal<Void>
        let id: Driver<String>
        let pw: Driver<String>
        let rePW: Driver<String>
    }

    struct Output {
        let result: Driver<String>
        let isEnabled: Driver<Bool>
    }

    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        let api = AuthAPI()
        let info = Driver.combineLatest(input.id, input.pw, input.rePW) { ($0, $1, $2) }

        let isEnabled = info.map { (id, pw, rePw) -> Bool in
            if id.count > 5 && pw.range(of: #"\b[A-Za-z0-9]{8,}\b"#, options: .regularExpression) != nil && pw == rePw {
                return true
            }
            return false
        }.asDriver()

        let isSucceed = input.signUpTaps.withLatestFrom(info).flatMap { (id, pw, rePw) -> Driver<String> in
            return api.postSignUp(id: id, pw: pw, rePW: rePw).map { (result) -> String in
                switch result {
                case .created: return "성공"
                case .badRequest: return "유효하지 않은 요청"
                case .conflict: return "존재하는 사용자"
                case .serverError: return "서버에러"
                default: return ""
                }
            }.asDriver(onErrorJustReturn: "")
        }

        return Output(result: isSucceed, isEnabled: isEnabled)
    }

}
