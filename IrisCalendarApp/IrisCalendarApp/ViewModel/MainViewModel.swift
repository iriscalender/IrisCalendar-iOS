//
//  MainViewModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/11/25.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    struct Input {
        let selectedDate: Signal<String>
        let selectedScheduleIndexPath: Signal<IndexPath>
        let loadData: Signal<Void>
        let doneTap: Signal<Void>
        let updateTap: Signal<Void>
    }

    struct Output {
        let bookedSchedules: Driver<[String: String]>
        let dailySchedule: Driver<[DailySchedule]>
        let selectedFixScheduleID: Signal<String>
        let selectedAutoScheduleID: Signal<String>
        let selectedScheduleName: Signal<String>
        let result: Signal<String>
    }

    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        let api = CalendarAPI()
        let bookedSchedules = PublishRelay<[String: String]>()
        let dailySchedule = PublishRelay<[DailySchedule]>()
        let selectedFixScheduleID = PublishRelay<String>()
        let selectedAutoScheduleID = PublishRelay<String>()
        let result = PublishSubject<String>()
        let info = Signal.combineLatest(input.selectedScheduleIndexPath, dailySchedule.asSignal()).asObservable()
        let selectedSchedule = info.filter { !$0.1.isEmpty } .map { $1[$0.row] }
        let selectedScheduleName = input.selectedScheduleIndexPath.asObservable().withLatestFrom(selectedSchedule).map { $0.scheduleName }

        input.loadData.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            api.getBookedCalendar().subscribe(onNext: { (response, networkingResult) in
                switch networkingResult {
                case .ok:
                    var result = [String: String]()
                    response!.schedules.forEach { result[$0.date] = $0.category }
                    bookedSchedules.accept(result)
                case .noContent: result.onNext("일정이 없습니다")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버 오류")
                default: result.onNext("일정을 불러올 수 없습니다")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.selectedDate.asObservable().subscribe(onNext: { [weak self] (date) in
            guard let self = self else { return }
            api.getDailyCalendar(date).subscribe(onNext: { (response, networkingResult) in
                switch networkingResult {
                case .ok: dailySchedule.accept(self.makeDailySchedule(response!))
                case .noContent: result.onNext("일정이 없습니다")
                case .badRequest: result.onNext("잘못된 일정")
                case .unauthorized: result.onNext("유효하지 않은 토큰")
                case .serverError: result.onNext("서버 오류")
                default: result.onNext("일정을 불러올 수 없습니다")
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.doneTap.asObservable().withLatestFrom(info).subscribe(onNext: { [weak self] (indexPath, schedules) in
            guard let self = self else { return }
            let schedule = schedules[indexPath.row]
            if schedule.isAuto {
                api.deleteAutoCalendar(String(schedule.calendarID)).subscribe(onNext: { networkingResult in
                    switch networkingResult {
                    case .ok:
                        var schedules = schedules
                        schedules.remove(at: indexPath.row)
                        dailySchedule.accept(schedules)
                        result.onNext("삭제 성공")
                    case .noContent: result.onNext("일정이 없습니다")
                    case .unauthorized: result.onNext("유효하지 않은 토큰")
                    case .serverError: result.onNext("서버 오류")
                    default: result.onNext("일정을 불러올 수 없습니다")
                    }
                }).disposed(by: self.disposeBag)
            } else {
                api.deleteFixCalendar(String(schedule.calendarID)).subscribe(onNext: { networkingResult in
                    switch networkingResult {
                    case .ok:
                        var schedules = schedules
                        schedules.remove(at: indexPath.row)
                        dailySchedule.accept(schedules)
                        result.onNext("삭제 성공")
                    case .noContent: result.onNext("일정이 없습니다")
                    case .unauthorized: result.onNext("유효하지 않은 토큰")
                    case .serverError: result.onNext("서버 오류")
                    default: result.onNext("일정을 불러올 수 없습니다")
                    }
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)

        input.updateTap.asObservable().withLatestFrom(selectedSchedule).subscribe(onNext: { (schedule) in
            if schedule.isAuto {
                selectedAutoScheduleID.accept(String(schedule.calendarID))
            } else {
                selectedFixScheduleID.accept(String(schedule.calendarID))
            }
        }).disposed(by: disposeBag)

        return Output(bookedSchedules: bookedSchedules.asDriver(onErrorJustReturn: [:]),
                      dailySchedule: dailySchedule.asDriver(onErrorJustReturn: []),
                      selectedFixScheduleID: selectedFixScheduleID.asSignal(),
                      selectedAutoScheduleID: selectedAutoScheduleID.asSignal(),
                      selectedScheduleName: selectedScheduleName.asSignal(onErrorJustReturn: ""),
                      result: result.asSignal(onErrorJustReturn: "오류 발생"))
    }

    private func makeDailySchedule(_ schedule: DailyScheduleModel) -> [DailySchedule] {
        var result = [DailySchedule]()
        schedule.autoSchedules.forEach { result.append(DailySchedule(calendarID: $0.calendarID,
                                                                     category: IrisCategory.Category.toCategory(category: $0.category),
                                                                     scheduleName: $0.scheduleName,
                                                                     startTime: IrisDateFormat.toTime(dateAndTime: $0.startTime),
                                                                     endTime: IrisDateFormat.toTime(dateAndTime: $0.endTime),
                                                                     isAuto: true)) }
        schedule.fixSchedules.forEach { result.append(DailySchedule(calendarID: $0.calendarID,
                                                                    category: IrisCategory.Category.toCategory(category: $0.category),
                                                                    scheduleName: $0.scheduleName,
                                                                    startTime: IrisDateFormat.toTime(dateAndTime: $0.startTime),
                                                                    endTime: IrisDateFormat.toTime(dateAndTime: $0.endTime),
                                                                    isAuto: false)) }
        return result.sorted { IrisDateFormat.time.isStartFaster(startTime: $0.startTime, endTime: $1.startTime) }
    }

}
