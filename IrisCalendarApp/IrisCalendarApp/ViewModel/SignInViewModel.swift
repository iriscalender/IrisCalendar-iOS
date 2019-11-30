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
    private let disposeBag = DisposeBag()

    struct Input {
        let userID: Driver<String>
        let userPW: Driver<String>
        let doneTap: Signal<Void>
    }

    struct Output {
        let isEnabled: Driver<Bool>
        let result: Signal<String>
    }

    func transform(input: SignInViewModel.Input) -> SignInViewModel.Output {
        let api = AuthAPI()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.userID, input.userPW)
        let isEnabled = info.map { IrisFilter.checkIDPW(id: $0, pw: $1) }

        input.doneTap.withLatestFrom(info).asObservable().subscribe(onNext: { [weak self] (userID, userPW) in
            guard let strongSelf = self else { return }
            api.postSignIn(userID: userID, userPW: userPW).subscribe(onNext: { (response) in
                switch response {
                case .ok : result.onCompleted()
                case .badRequest : result.onNext("유효하지 않은 요청")
                case .serverError : result.onNext("서버오류")
                default : result.onNext("로그인 실패")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        return Output(isEnabled: isEnabled.asDriver(),
                      result: result.asSignal(onErrorJustReturn: "로그인 실패"))
    }
}
