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
        let isSucceed: Driver<Bool>

    }

    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        
    }

}
