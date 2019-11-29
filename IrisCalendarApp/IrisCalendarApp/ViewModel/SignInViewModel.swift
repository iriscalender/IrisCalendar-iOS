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
        let doneTaps: Signal<Void>
    }
    
    struct Output {
        let isEnabled: Driver<Bool>
        let result: Signal<String>
    }
    
    func transform(input: SignInViewModel.Input) -> SignInViewModel.Output {
        let api = AuthAPI()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.userID, input.userPW)
        
        let isEnabled = info.map { $0.count > 5 && $1.range(of: "[A-Za-z0-9]{8,}", options: .regularExpression) != nil }.asDriver()
        
        input.doneTaps.withLatestFrom(info).asObservable().subscribe (onNext: { [weak self] (id, pw) in
            guard let strongSelf = self else { return }
            api.postSignIn(userID: id, userPW: pw).subscribe (onNext: { (response) in
                switch response {
                case .ok : result.onCompleted()
                case .badRequest : result.onNext("유효하지 않은 요청")
                case .serverError : result.onNext("서버오류")
                default : result.onNext("로그인 실패")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)
        
        return Output(isEnabled: isEnabled, result: result.asSignal(onErrorJustReturn: "로그인 실패"))
    }
    
}
