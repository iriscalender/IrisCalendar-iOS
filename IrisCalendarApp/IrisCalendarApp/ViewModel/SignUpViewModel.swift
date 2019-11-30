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
        let doneTap: Signal<Void>
    }

    struct Output {
        let isEnabled: Driver<Bool>
        let result: Signal<String>
    }

    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        let api = AuthAPI()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.userID, input.userPW, input.userRePW)
        let isEnabled = info.map { IrisFilter.checkIDPW(userID: $0, userPW: $1) && $1 == $2 }

        input.doneTap.withLatestFrom(info).asObservable().subscribe(onNext: { [weak self] (userID, userPW, userRePW) in
            guard let self = self else { return }
            api.postSignUp(userID: userID, userPW: userPW, userRePW: userRePW).subscribe(onNext: { (response) in
                switch response {
                case .created: result.onCompleted()
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .conflict: result.onNext("이미 존재하는 회원")
                case .serverError : result.onNext("서버오류")
                default: result.onNext("회원가입 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        return Output(isEnabled: isEnabled.asDriver(),
                      result: result.asSignal(onErrorJustReturn: "회원가입 실패"))
    }
}
