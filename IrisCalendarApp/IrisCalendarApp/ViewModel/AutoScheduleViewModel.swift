//
//  AutoScheduleViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/24.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class AutoScheduleViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let scheduleStatus: Driver<ScheduleStatus>
        let scheduleName: Driver<String>
        let endYear: Driver<String>
        let endMonth: Driver<String>
        let endDay: Driver<String>
        let theTimeRequired: Driver<String>
        let isMoreImportant: Driver<Bool>
        let purlpleTap: Signal<Void>
        let blueTap: Signal<Void>
        let pinkTap: Signal<Void>
        let orangeTap: Signal<Void>
        let doneTap: Signal<Void>
    }

    struct Output {
        let defaultScheduleName: Driver<String>
        let defaultEndYear: Driver<String>
        let defaultEndMonth: Driver<String>
        let defaultEndDay: Driver<String>
        let defaultTheTimeRequired: Driver<String>
        let defaultIsMoreImportant: Driver<Bool>
        let isEnabled: Driver<Bool>
        let purpleSize: Driver<CGFloat>
        let blueSize: Driver<CGFloat>
        let pinkSize: Driver<CGFloat>
        let orangeSize: Driver<CGFloat>
        let result: Signal<String>
    }

    func transform(input: AutoScheduleViewModel.Input) -> AutoScheduleViewModel.Output {
        let api = CalendarAPI()
        let selectedCategory = BehaviorRelay<IrisCategory.Category>(value: .purple)
        let purpleSize = BehaviorRelay<CGFloat>(value: 15)
        let blueSize = BehaviorRelay<CGFloat>(value: 10)
        let pinkSize = BehaviorRelay<CGFloat>(value: 10)
        let orangeSize = BehaviorRelay<CGFloat>(value: 10)
        let defaultScheduleName = PublishRelay<String>()
        let defaultEndYear = PublishRelay<String>()
        let defaultEndMonth = PublishRelay<String>()
        let defaultEndDay = PublishRelay<String>()
        let defaultTheTimeRequired = PublishRelay<String>()
        let defaultIsMoreImportant = PublishRelay<Bool>()
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(selectedCategory.asDriver(), input.scheduleName, input.endYear, input.endMonth, input.endDay, input.theTimeRequired, input.isMoreImportant) {
            AutoScheduleModel(category: $0.rawValue, scheduleName: $1, endTime: "\($2)-\($3)-\($4)", requiredTime: Int($5) ?? 0, isParticularImportant: $6)
        }
        let infoAndStatus = Driver.combineLatest(info, input.scheduleStatus) { ($0, $1) }
        let isEnabled = info.map { (model) -> Bool in
            if model.scheduleName.isEmpty ||
                model.requiredTime == 0 ||
                model.endTime.range(of: "(19|20)\\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])", options: .regularExpression) == nil ||
                model.requiredTime > 24 { return false }
            return true
        }.asDriver(onErrorJustReturn: false)

        input.scheduleStatus.asObservable().subscribe(onNext: { [weak self] (scheduleStatus) in
            guard let self = self else { return }
            switch scheduleStatus {
            case .update(let id):
                api.getAutoCalendar(id).asObservable().subscribe(onNext: { (response, networkingResult) in
                    switch networkingResult {
                    case .ok:
                        selectedCategory.accept(IrisCategory.Category.toCategory(category: response!.category))
                        defaultScheduleName.accept(response!.scheduleName)
                        let endDate = response!.endTime.components(separatedBy: ["-"])
                        defaultEndYear.accept(endDate[0])
                        defaultEndMonth.accept(endDate[1])
                        defaultEndDay.accept(endDate[2])
                        defaultTheTimeRequired.accept("\(response!.requiredTime)")
                        defaultIsMoreImportant.accept(response!.isParticularImportant)
                    case .badRequest: result.onNext("유효하지 않은 요청")
                    case .unauthorized: result.onNext("유효하지 않은 토큰")
                    case .serverError: result.onNext("서버오류")
                    default: result.onNext("기존 데이터 가져오기 실패")
                    }
                }).disposed(by: self.disposeBag)
            default: return
            }
        }).disposed(by: disposeBag)

        input.purlpleTap.asObservable().subscribe(onNext: { selectedCategory.accept(.purple) }).disposed(by: disposeBag)
        input.blueTap.asObservable().subscribe(onNext: { selectedCategory.accept(.blue) }).disposed(by: disposeBag)
        input.pinkTap.asObservable().subscribe(onNext: { selectedCategory.accept(.pink) }).disposed(by: disposeBag)
        input.orangeTap.asObservable().subscribe(onNext: { selectedCategory.accept(.orange) }).disposed(by: disposeBag)

        selectedCategory.subscribe(onNext: { (selectedCategory) in
            switch selectedCategory {
            case .purple:
                purpleSize.accept(15)
                blueSize.accept(10)
                pinkSize.accept(10)
                orangeSize.accept(10)
            case .blue:
                purpleSize.accept(10)
                blueSize.accept(15)
                pinkSize.accept(10)
                orangeSize.accept(10)
            case .pink:
                purpleSize.accept(10)
                blueSize.accept(10)
                pinkSize.accept(15)
                orangeSize.accept(10)
            case .orange:
                purpleSize.accept(10)
                blueSize.accept(10)
                pinkSize.accept(10)
                orangeSize.accept(15)
            }
        }).disposed(by: disposeBag)

        input.doneTap.withLatestFrom(infoAndStatus).asObservable().subscribe(onNext: { [weak self] (info, scheduleStatus) in
            guard let self = self else { return }
            switch scheduleStatus {
            case .add:
                api.addAutoCalendar(info).subscribe(onNext: {
                    let message = $0.toStringForSchedule(status: scheduleStatus)
                    if message == "성공" { result.onCompleted(); return }
                    result.onNext(message)
                }).disposed(by: self.disposeBag)
            case .update(let calendarID):
                api.updateAutoCalendar(info, calendarID: calendarID).subscribe(onNext: {
                    let message = $0.toStringForSchedule(status: scheduleStatus)
                    if message == "성공" { result.onCompleted(); return }
                    result.onNext(message)
                }).disposed(by: self.disposeBag)
            case .unknown: result.onNext("알수없는 status")
            }
        }).disposed(by: disposeBag)

        return Output(defaultScheduleName: defaultScheduleName.asDriver(onErrorJustReturn: ""),
                      defaultEndYear: defaultEndYear.asDriver(onErrorJustReturn: ""),
                      defaultEndMonth: defaultEndMonth.asDriver(onErrorJustReturn: ""),
                      defaultEndDay: defaultEndDay.asDriver(onErrorJustReturn: ""),
                      defaultTheTimeRequired: defaultTheTimeRequired.asDriver(onErrorJustReturn: ""),
                      defaultIsMoreImportant: defaultIsMoreImportant.asDriver(onErrorJustReturn: false),
                      isEnabled: isEnabled.asDriver(),
                      purpleSize: purpleSize.asDriver(),
                      blueSize: blueSize.asDriver(),
                      pinkSize: pinkSize.asDriver(),
                      orangeSize: orangeSize.asDriver(),
                      result: result.asSignal(onErrorJustReturn: "오류 발생"))
    }
}
