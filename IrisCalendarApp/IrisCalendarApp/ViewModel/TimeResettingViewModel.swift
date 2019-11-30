//
//  TimeResettingViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/05.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class TimeResettingViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let loadData: Completable
        let selectedTime: Driver<Date>
        let startTimeTap: Signal<Void>
        let endTimeTap: Signal<Void>
        let doneTap: Signal<Void>
    }

    struct Output {
        let startTime: Driver<String>
        let endTime: Driver<String>
        let isEnabled: Driver<Bool>
        let result: Signal<String>
    }

    func transform(input: TimeResettingViewModel.Input) -> TimeResettingViewModel.Output {
        let api = AllocationTimeAPI()
        let startTime = BehaviorRelay<String>(value: IrisDateFormat.time.rawValue)
        let endTime = BehaviorRelay<String>(value: IrisDateFormat.time.rawValue)
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(startTime.asDriver(), endTime.asDriver())
        let isEnabled = info.map { IrisDateFormat.time.isStartFaster(startTime: $0, endTime: $1) }

        input.loadData.subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            api.getAlloctionTime().subscribe(onNext: { (response, networkingResult) in
                switch networkingResult {
                case .ok:
                    startTime.accept(response!.startTime)
                    endTime.accept(response!.endTime)
                case .noContent: result.onNext("잘못된 접근")
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("할당시간 재설정 실패")
                }
            }).disposed(by: strongSelf.disposeBag)
        }.disposed(by: disposeBag)

        input.startTimeTap.withLatestFrom(input.selectedTime).asObservable().subscribe(onNext: {
            startTime.accept(IrisDateFormat.time.toString(date: $0))
        }).disposed(by: disposeBag)

        input.endTimeTap.withLatestFrom(input.selectedTime).asObservable().subscribe(onNext: {
            endTime.accept(IrisDateFormat.time.toString(date: $0))
        }).disposed(by: disposeBag)

        input.doneTap.withLatestFrom(info).asObservable().subscribe(onNext: { [weak self] (start, end) in
            guard let strongSelf = self else { return }
            api.updateAlloctionTime(startTime: start, endTime: end).subscribe(onNext: { (response) in
                switch response {
                case .ok: result.onCompleted()
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("할당시간 재설정 실패")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        return Output(startTime: startTime.asDriver(),
                      endTime: endTime.asDriver(),
                      isEnabled: isEnabled,
                      result: result.asSignal(onErrorJustReturn: "할당시간 재설정 실패"))
    }
}
