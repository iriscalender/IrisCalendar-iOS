//
//  TimeSettingViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/29.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class TimeSettingViewModel: ViewModelType {

    private let allocationTime = "HH:mm"
    private let disposeBag = DisposeBag()

    struct Input {
        let timeSettingTaps: Signal<Void>
        let startTimeTaps: Signal<Void>
        let endTimeTaps: Signal<Void>
        let selectedTime: Driver<Date>
    }

    struct Output {
        let startTime: Driver<String>
        let endTime: Driver<String>
        let isEnabled: Driver<Bool>
        let result: Driver<String>
    }

    func transform(input: TimeSettingViewModel.Input) -> TimeSettingViewModel.Output {
        let api = AllocationTimeAPI()
        let startTime = BehaviorRelay<String>(value: allocationTime)
        let endTime = BehaviorRelay<String>(value: allocationTime)
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(startTime.asDriver(), endTime.asDriver())

        let formatter = DateFormatter()
        formatter.dateFormat = allocationTime

        let isEnabled = info.map { (start, end) -> Bool in
            if start == "HH:mm" || end == "HH:mm" { return false }
            if start.components(separatedBy: [":"]).joined() < end.components(separatedBy: [":"]).joined() {
                return true
            }
            result.onNext("종료시간이 더 빠릅니다")
            return false
        }.asDriver(onErrorJustReturn: false)

        input.timeSettingTaps.withLatestFrom(info).asObservable().subscribe({ [weak self] (event) in
            guard let time = event.element, let strongSelf = self else { return }
            api.setAlloctionTime(startTime: time.0, endTime: time.1).asObservable().subscribe { (event) in
                switch event.element?.1 {
                case .ok: result.onCompleted()
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("")
                }
            }.disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        input.startTimeTaps.withLatestFrom(input.selectedTime).asObservable()
            .subscribe { (event) in
                guard let time = event.element else { return }
                startTime.accept(formatter.string(from: time))
        }.disposed(by: disposeBag)

        input.endTimeTaps.withLatestFrom(input.selectedTime).asObservable()
            .subscribe { (event) in
                guard let time = event.element else { return }
                endTime.accept(formatter.string(from: time))
        }.disposed(by: disposeBag)

        return Output(startTime: startTime.asDriver(),
                      endTime: endTime.asDriver(),
                      isEnabled: isEnabled,
                      result: result.asDriver(onErrorJustReturn: ""))
    }
}
