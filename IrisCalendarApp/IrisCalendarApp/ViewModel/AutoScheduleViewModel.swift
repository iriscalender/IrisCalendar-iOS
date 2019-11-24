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
        let saveTaps: Signal<Void>
        let scheduleStatus: Signal<ScheduleStatus>
        let viewDidLoad: Signal<Void>
        let purlpleTaps: Signal<Void>
        let blueTaps: Signal<Void>
        let pinkTaps: Signal<Void>
        let orangeTaps: Signal<Void>
        let scheduleName: Driver<String>
        let endYear: Driver<String>
        let endMonth: Driver<String>
        let endDay: Driver<String>
        let theTimeRequired: Driver<String>
        let isMoreImportant: Driver<Bool>
    }

    struct Output {
        let purpleTxt: Driver<String>
        let blueTxt: Driver<String>
        let pinkTxt: Driver<String>
        let orangeTxt: Driver<String>
        let purpleSize: Driver<CGFloat>
        let blueSize: Driver<CGFloat>
        let pinkSize: Driver<CGFloat>
        let orangeSize: Driver<CGFloat>
        let defaultScheduleName: Driver<String>
        let defaultEndYear: Driver<String>
        let defaultEndMonth: Driver<String>
        let defaultEndDay: Driver<String>
        let defaultTheTimeRequired: Driver<String>
        let deaultIsMoreImportant: Driver<Bool>
        let isEnabled: Driver<Bool>
        let result: Driver<String>
    }

    func transform(input: AutoScheduleViewModel.Input) -> AutoScheduleViewModel.Output {
        let categoryAPI = CategoryAPI()
        let api = CalendarAPI()

        let purpleTxt = BehaviorRelay<String>(value: "기타")
        let blueTxt = BehaviorRelay<String>(value: "회의, 미팅")
        let pinkTxt = BehaviorRelay<String>(value: "운동")
        let orangeTxt = BehaviorRelay<String>(value: "과제, 공부")
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
        let selectedCategory = BehaviorRelay<IrisCategory>(value: .purple)
        let result = PublishSubject<String>()
        let info = Driver.combineLatest(selectedCategory.asDriver(), input.scheduleName, input.endYear, input.endMonth, input.endDay, input.theTimeRequired, input.isMoreImportant) {
            AutoScheduleModel(category: $0.rawValue, scheduleName: $1, endTime: "\($2)-\($3)-\($4)", requiredTime: Int($5) ?? 0, isParticularImportant: $6)
        }

        let isEnabled = info.map { (model) -> Bool in
            if model.scheduleName.isEmpty || model.requiredTime == 0 ||
                model.endTime.range(of: "(19|20)\\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])", options: .regularExpression) == nil ||
                model.requiredTime > 24 { return false }
            return true
        }.asDriver(onErrorJustReturn: false)

        input.saveTaps.withLatestFrom(input.scheduleStatus).asObservable().subscribe(onNext: { [weak self] (scheduleStatus) in
            guard let strongSelf = self else { return }
            switch scheduleStatus {
            case .add:
                strongSelf.addSchedule(info.asObservable()).subscribe(onNext: { (message) in
                    guard message != "성공" else { result.onCompleted(); return }
                    result.onNext(message)
                }).disposed(by: strongSelf.disposeBag)
            case .update(let id):
                strongSelf.updateSchedule(info.asObservable(), id: id).subscribe(onNext: { (message) in
                    guard message != "성공" else { result.onCompleted(); return }
                    result.onNext(message)
                }).disposed(by: strongSelf.disposeBag)
            case .unknown: result.onNext("알수없는 status")
            }
        }).disposed(by: disposeBag)

        input.viewDidLoad.withLatestFrom(input.scheduleStatus).asObservable().subscribe(onNext: { [weak self] (scheduleStatus) in
            guard let strongSelf = self else { return }
            categoryAPI.getCategory().asObservable().subscribe(onNext: { (response, networkingResult) in
                switch networkingResult {
                case .ok:
                    purpleTxt.accept(response!.purple)
                    blueTxt.accept(response!.blue)
                    pinkTxt.accept(response!.pink)
                    orangeTxt.accept(response!.orange)
                case .badRequest: result.onNext("유효하지 않은 요청")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버오류")
                default: result.onNext("카테고리 불러오기 실패")
                }
            }).disposed(by: strongSelf.disposeBag)

            switch scheduleStatus {
            case .update(let id):
                api.getAutoCalendar(id).asObservable().subscribe(onNext: { (response, networkingResult) in
                    switch networkingResult {
                    case .ok:
                        selectedCategory.accept(IrisCategory.getIrisCategory(category: response!.category))
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
                }).disposed(by: strongSelf.disposeBag)
            default: return
            }
        }).disposed(by: disposeBag)

        input.purlpleTaps.asObservable().subscribe(onNext: { (_) in
            selectedCategory.accept(.purple)
        }).disposed(by: disposeBag)

        input.blueTaps.asObservable().subscribe(onNext: { (_) in
            selectedCategory.accept(.blue)
        }).disposed(by: disposeBag)

        input.pinkTaps.asObservable().subscribe(onNext: { (_) in
            selectedCategory.accept(.pink)
        }).disposed(by: disposeBag)

        input.orangeTaps.asObservable().subscribe(onNext: { (_) in
            selectedCategory.accept(.orange)
        }).disposed(by: disposeBag)

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

        return Output(purpleTxt: purpleTxt.asDriver(onErrorJustReturn: ""),
                      blueTxt: blueTxt.asDriver(onErrorJustReturn: ""),
                      pinkTxt: pinkTxt.asDriver(onErrorJustReturn: ""),
                      orangeTxt: orangeTxt.asDriver(onErrorJustReturn: ""),
                      purpleSize: purpleSize.asDriver(),
                      blueSize: blueSize.asDriver(),
                      pinkSize: pinkSize.asDriver(),
                      orangeSize: orangeSize.asDriver(),
                      defaultScheduleName: defaultScheduleName.asDriver(onErrorJustReturn: ""),
                      defaultEndYear: defaultEndYear.asDriver(onErrorJustReturn: ""),
                      defaultEndMonth: defaultEndMonth.asDriver(onErrorJustReturn: ""),
                      defaultEndDay: defaultEndDay.asDriver(onErrorJustReturn: ""),
                      defaultTheTimeRequired: defaultTheTimeRequired.asDriver(onErrorJustReturn: ""),
                      deaultIsMoreImportant: defaultIsMoreImportant.asDriver(onErrorJustReturn: false),
                      isEnabled: isEnabled.asDriver(),
                      result: result.asDriver(onErrorJustReturn: "오류 발생"))
    }

    private func addSchedule(_ info: Observable<AutoScheduleModel>) -> Observable<String> {
        return info.flatMap { (model) -> Observable<String> in
            return CalendarAPI().addAutoCalendar(model).map { (_, networkingResult) -> String in
                switch networkingResult {
                case .ok: return "성공"
                case .badRequest: return "유효하지 않은 요청"
                case .unauthorized: return "유효하지 않은 토큰"
                case .conflict: return "소화할 수 없는 일정"
                case .serverError: return "서버오류"
                default: return "일정 추가하기 실패"
                }
            }
        }
    }

    private func updateSchedule(_ info: Observable<AutoScheduleModel>, id: Int) -> Observable<String> {
        return info.flatMap { (model) -> Observable<String> in
            return CalendarAPI().updateAutoCalendar(model, id: id).map { (_, networkingResult) -> String in
                switch networkingResult {
                case .ok: return "성공"
                case .badRequest: return "유효하지 않은 요청"
                case .unauthorized: return "유효하지 않은 토큰"
                case .conflict: return "소화할 수 없는 일정"
                case .serverError: return "서버오류"
                default: return "일정 수정하기 실패"
                }
            }
        }
    }
}
