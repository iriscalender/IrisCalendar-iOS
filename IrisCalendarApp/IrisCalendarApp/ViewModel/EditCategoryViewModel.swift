//
//  EditCategoryViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/05.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class EditCategoryViewModel: ViewModelType {

    private let disposeBag = DisposeBag()

    struct Input {
        let saveTaps: Signal<Void>
        let viewDidLoad: Signal<Void>
        let purpleTxt: Driver<String>
        let blueTxt: Driver<String>
        let pinkTxt: Driver<String>
        let orangeTxt: Driver<String>
    }

    struct Output {
        let purpleTxt: Driver<String>
        let blueTxt: Driver<String>
        let pinkTxt: Driver<String>
        let orangeTxt: Driver<String>
        let isEnabled: Driver<Bool>
        let result: Driver<String>
    }

    func transform(input: EditCategoryViewModel.Input) -> EditCategoryViewModel.Output {
        let api = CategoryAPI()
        let purple = BehaviorRelay<String>(value: "")
        let blue = BehaviorRelay<String>(value: "")
        let pink = BehaviorRelay<String>(value: "")
        let orange = BehaviorRelay<String>(value: "")
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.purpleTxt, input.blueTxt, input.pinkTxt, input.orangeTxt) {
            CategoryModel(purple: $0, blue: $1, pink: $2, orange: $3)
        }

        let isEnabled = info.map { !($0.purple.isEmpty || $0.blue.isEmpty || $0.pink.isEmpty || $0.orange.isEmpty) }.asDriver()

        input.saveTaps.withLatestFrom(info).asObservable().subscribe(onNext: { [weak self] (category) in
            guard let strongSelf = self else { return }
            api.updateCategory(category: category).asObservable().subscribe(onNext: { (_, networkingResult) in
                switch networkingResult {
                case .ok: result.onCompleted()
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        input.viewDidLoad.withLatestFrom(info).asObservable().subscribe(onNext: { [weak self] (category) in
            guard let strongSelf = self else { return }
            api.getCategory().asObservable().subscribe(onNext: { (response, networkingresult) in
                switch networkingresult {
                case .ok:
                    purple.accept(response!.purple)
                    blue.accept(response!.blue)
                    pink.accept(response!.pink)
                    orange.accept(response!.orange)
                    result.onNext("불러오기 성공")
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        return Output(purpleTxt: purple.asDriver(),
                      blueTxt: blue.asDriver(),
                      pinkTxt: pink.asDriver(),
                      orangeTxt: orange.asDriver(),
                      isEnabled: isEnabled.asDriver(),
                      result: result.asDriver(onErrorJustReturn: ""))
    }
}
