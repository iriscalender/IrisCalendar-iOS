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
    private let disposeBag = DisposeBag()

    struct Input {
        let userID: Driver<String>
        let userPW: Driver<String>
        let userRePW: Driver<String>
        let doneTaps: Signal<Void>
    }
    
    struct Output {
        let isEnabled: Driver<Bool>
        let result: Signal<String>
    }

    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        let api = AuthAPI()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.userID, input.userPW, input.userRePW)

        let isEnabled = info.map { $0.count > 5 && $1.range(of: "[A-Za-z0-9]{8,}", options: .regularExpression) != nil && $1 == $2 }.asDriver()

        input.doneTaps.withLatestFrom(info).asObservable().subscribe (onNext: { [weak self] (id, pw, rePW) in
            guard let strongSelf = self else { return }
            api.postSignUp(userID: id, userPW: pw, userRePW: rePW).subscribe (onNext: { (response) in
                switch response {
                case .ok : result.onCompleted()
                case .badRequest : result.onNext("유효하지 않은 요청")
                case .serverError : result.onNext("서버오류")
                default : result.onNext("회원가입 실패")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(isEnabled: isEnabled, result: result.asSignal(onErrorJustReturn: "회원가입 실패"))
    }
    
}
