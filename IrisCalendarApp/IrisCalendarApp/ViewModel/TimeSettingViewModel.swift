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
        let result: Driver<String>
        let startTime: Driver<String>
        let endTime: Driver<String>
        let isEnabled: Driver<Bool>
    }

    func transform(input: TimeSettingViewModel.Input) -> TimeSettingViewModel.Output {
        let api = AllocationTimeAPI()
        let startTime = BehaviorRelay<String>(value: allocationTime)
        let endTime = BehaviorRelay<String>(value: allocationTime)
        let info = Driver.combineLatest(startTime.asDriver(), endTime.asDriver())

        let formatter = DateFormatter()
        formatter.dateFormat = allocationTime

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

        let isEnabled = input.timeSettingTaps.withLatestFrom(info)
            .map { [weak self] (start, end) -> Bool in
                guard let strongSelf = self else { return false}
                if let compareResult = formatter.date(from: start)?.compare(formatter.date(from: end)!),
                    start != strongSelf.allocationTime,
                    end != strongSelf.allocationTime,
                    compareResult == .orderedAscending {
                    return true
                }
                return false
        }.asDriver(onErrorJustReturn: false)

        let result = input.timeSettingTaps.withLatestFrom(info)
            .flatMap { (start, end) -> Driver<String> in
                return api.setAlloctionTime(startTime: start, endTime: end)
                    .map { (response) -> String in
                        switch response.1 {
                        case .ok: return "성공"
                        case .badRequest: return "유효하지 않은 요청"
                        case .unauthorized: return "유효하지 않은 토큰"
                        case .serverError: return "서버오류"
                        default: return ""
                        }
                }.asDriver(onErrorJustReturn: "")
        }

        return Output(result: result,
                      startTime: startTime.asDriver(),
                      endTime: endTime.asDriver(),
                      isEnabled: isEnabled)
    }
}
