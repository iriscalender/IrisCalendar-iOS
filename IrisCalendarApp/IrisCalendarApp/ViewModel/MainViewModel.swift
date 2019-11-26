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

    typealias BookedSchedules = [AnyHashable: String]

    private let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Driver<Void>
        let selectedDate: Driver<String>
        let selectedScheduleIndexPath: Signal<IndexPath>
        let doneTaps: Signal<Void>
    }

    struct Output {
        let bookedSchedules: Driver<BookedSchedules>
        let dailySchedule: Driver<[DailySchedule]>
        let result: Signal<String>
        let deleteIndexPath: Signal<IndexPath>
        let selectedSchedule: Signal<DailySchedule>
    }

    func transform(input: MainViewModel.Input) -> MainViewModel.Output {
        let api = CalendarAPI()
        let result = PublishRelay<String>()
        let bookedSchedules = PublishRelay<BookedSchedules>()
        let dailySchedule = PublishRelay<[DailySchedule]>()
        let deleteIndexPath = PublishRelay<IndexPath>()
        let info = Signal.combineLatest(input.selectedScheduleIndexPath, dailySchedule.asSignal()).asObservable()

        let selectedSchedule = info.map { $1[$0.row] }

        input.viewDidLoad.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            api.getBookedCalendar().subscribe(onNext: { (response, networkingResult) in
                switch networkingResult {
                case .ok:
                    var result = BookedSchedules()
                    response!.schedules.forEach { result[$0.date] = $0.category }
                    bookedSchedules.accept(result)
                case .noContent: result.accept("일정이 없습니다")
                case .unauthorized: result.accept("유효하지 않은 토큰")
                case .serverError: result.accept("서버 오류")
                default: result.accept("일정을 불러올 수 없습니다")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        input.selectedDate.asObservable().subscribe(onNext: { [weak self] (date) in
            guard let strongSelf = self else { return }
            api.getDailyCalendar(date).subscribe(onNext: { (response, networkingResult) in
                switch networkingResult {
                case .ok: dailySchedule.accept(strongSelf.makeDailySchedule(response!))
                case .noContent: result.accept("일정이 없습니다")
                case .badRequest: result.accept("잘못된 일정")
                case .unauthorized: result.accept("유효하지 않은 토큰")
                case .serverError: result.accept("서버 오류")
                default: result.accept("일정을 불러올 수 없습니다")
                }
            }).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)

        input.doneTaps.asObservable().withLatestFrom(info).subscribe(onNext: { [weak self] (indexPath, schedules) in
            guard let strongSelf = self else { return }
            let schedule = schedules[indexPath.row]
            if schedule.isAuto {
                api.deleteAutoCalendar(schedule.id).subscribe(onNext: { networkingResult in
                    switch networkingResult {
                    case .ok: deleteIndexPath.accept(indexPath)
                    case .noContent: result.accept("일정이 없습니다")
                    case .unauthorized: result.accept("유효하지 않은 토큰")
                    case .serverError: result.accept("서버 오류")
                    default: result.accept("일정을 불러올 수 없습니다")
                    }
                }).disposed(by: strongSelf.disposeBag)
            } else {
                api.deleteFixCalendar(schedule.id).subscribe(onNext: { networkingResult in
                    switch networkingResult {
                    case .ok: deleteIndexPath.accept(indexPath)
                    case .noContent: result.accept("일정이 없습니다")
                    case .unauthorized: result.accept("유효하지 않은 토큰")
                    case .serverError: result.accept("서버 오류")
                    default: result.accept("일정을 불러올 수 없습니다")
                    }
                }).disposed(by: strongSelf.disposeBag)
            }
        }).disposed(by: disposeBag)

        return Output(bookedSchedules: bookedSchedules.asDriver(onErrorJustReturn: BookedSchedules()),
                      dailySchedule: dailySchedule.asDriver(onErrorJustReturn: []),
                      result: result.asSignal(),
                      deleteIndexPath: deleteIndexPath.asSignal(),
                      selectedSchedule: selectedSchedule.asSignal(onErrorJustReturn: DailySchedule(id: "",
                                                                                                   category: IrisCategory.purple,
                                                                                                   scheduleName: "",
                                                                                                   startTime: "",
                                                                                                   endTime: "",
                                                                                                   isAuto: false)))
    }

    private func makeDailySchedule(_ schedule: DailyScheduleModel) -> [DailySchedule] {
        var result = [DailySchedule]()
        schedule.autoSchedules.forEach { result.append(DailySchedule(id: $0.id,
                                                                     category: IrisCategory.getIrisCategory(category: $0.category),
                                                                     scheduleName: $0.scheduleName,
                                                                     startTime: $0.startTime,
                                                                     endTime: $0.endTime,
                                                                     isAuto: true)) }
        schedule.fixSchedules.forEach { result.append(DailySchedule(id: $0.id,
                                                                    category: IrisCategory.getIrisCategory(category: $0.category),
                                                                    scheduleName: $0.scheduleName,
                                                                    startTime: $0.startTime,
                                                                    endTime: $0.endTime,
                                                                    isAuto: false)) }
        return result.sorted {
            $0.startTime.components(separatedBy: ["-",":"]).joined() > $1.startTime.components(separatedBy: ["-",":"]).joined()
        }
    }


}
