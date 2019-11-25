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
        let SignInTaps: Signal<Void>
        let id: Driver<String>
        let pw: Driver<String>
    }
    
    struct Output {
        let isEnabled: Driver<Bool>
        let result: Driver<String>
    }
    
    func transform(input: SignInViewModel.Input) -> SignInViewModel.Output {
        let api = AuthAPI()
        let info = Driver.combineLatest(input.id, input.pw)
        
        let isEnabled = info.map { (id, pw) -> Bool in
            if id.count > 5 && pw.range(of: "[A-Za-z0-9]{8,}", options: .regularExpression) != nil {
                return true
            }
            return false
        }.asDriver()
        
        let result = input.SignInTaps.withLatestFrom(info).flatMap { (id, pw) -> Driver<String> in
            return api.postSignIn(id: id, pw: pw).map { (result) -> String in
                switch result {
                case .ok : return "성공"
                case .badRequest : return "유효하지 않은 요청"
                case .serverError : return "서버오류"
                default : return "로그인 실패"
                }
            }.asDriver(onErrorJustReturn: "로그인 실패")
        }
        
        return Output(isEnabled: isEnabled, result: result)
    }
    
    
}