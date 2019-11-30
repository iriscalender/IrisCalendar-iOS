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
        let loadData: Completable
        let purpleTxt: Driver<String>
        let blueTxt: Driver<String>
        let pinkTxt: Driver<String>
        let orangeTxt: Driver<String>
        let doneTap: Signal<Void>
    }

    struct Output {
        let purpleTxt: Driver<String>
        let blueTxt: Driver<String>
        let pinkTxt: Driver<String>
        let orangeTxt: Driver<String>
        let isEnabled: Driver<Bool>
        let result: Signal<String>
    }

    func transform(input: EditCategoryViewModel.Input) -> EditCategoryViewModel.Output {
        let api = CategoryAPI()
        let category = IrisCategory.shared
        let purple = BehaviorRelay<String>(value: category.purple)
        let blue = BehaviorRelay<String>(value: category.blue)
        let pink = BehaviorRelay<String>(value: category.pink)
        let orange = BehaviorRelay<String>(value: category.orange)
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(input.purpleTxt, input.blueTxt, input.pinkTxt, input.orangeTxt) {
            CategoryModel(purple: $0, blue: $1, pink: $2, orange: $3)
        }
        let isEnabled = info.map { !($0.purple.isEmpty || $0.blue.isEmpty || $0.pink.isEmpty || $0.orange.isEmpty) }

        input.doneTap.withLatestFrom(info).asObservable().subscribe(onNext: { [weak self] (info) in
            guard let self = self else { return }
            api.updateCategory(info).subscribe(onNext: { (response) in
                switch response {
                case .ok: result.onCompleted()
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("카테고리 수정 실패")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        return Output(purpleTxt: purple.asDriver(),
                      blueTxt: blue.asDriver(),
                      pinkTxt: pink.asDriver(),
                      orangeTxt: orange.asDriver(),
                      isEnabled: isEnabled.asDriver(),
                      result: result.asSignal(onErrorJustReturn: "카테고리 수정 실패"))
    }
}
