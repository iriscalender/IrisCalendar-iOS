//
//  MainVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import FSCalendar
import BubbleTransition
import RxSwift
import RxCocoa

class MainVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addScheduleBtn: UIButton!
    @IBOutlet weak var irisCalendar: FSCalendar!
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private let dateFormatter = DateFormatter()
    private let viewModel = MainViewModel()
    private let mainViewDidLoad = BehaviorRelay<Void>(value: ())
    private let doneTaps = PublishRelay<Void>()
    private let updateTaps = PublishRelay<Void>()
    private var bookedSchedules = BehaviorRelay<MainViewModel.BookedSchedules>(value: [:])

    private lazy var today: String = {
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: Date())
    }()
    private lazy var selectedDate = BehaviorSubject<String>(value: today)

    let disposeBag = DisposeBag()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginCheck()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MenubarVC {
            controller.delegate = self
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        } else if let controller = segue.destination as? AddScheduleMenubarVC {
            controller.delegate = self
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }

    private func loginCheck() {
        if Token.token == nil {
            self.presentVC(identifier: "AuthNC")
        } else {
            setUpUI()
            bindViewModel()
        }
    }

    private func setUpUI() {
        irisCalendar.appearance.titleFont = UIFont(name: "NanumSquareEB", size: 15)
        irisCalendar.appearance.weekdayFont = UIFont(name: "NanumSquareEB", size: 15)
        irisCalendar.appearance.headerTitleFont = UIFont(name: "NanumSquareEB", size: 20)
        irisCalendar.appearance.titleDefaultColor = IrisColor.calendarDefault
        irisCalendar.appearance.weekdayTextColor = IrisColor.calendarTitle
        irisCalendar.appearance.headerTitleColor = IrisColor.calendarTitle
        irisCalendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        irisCalendar.appearance.todayColor = IrisColor.authTxtField
        irisCalendar.appearance.selectionColor = IrisColor.mainHalfClear

        irisCalendar.delegate = self
        irisCalendar.dataSource = self
    }

    private func bindViewModel() {
        let input = MainViewModel.Input(viewDidLoad: mainViewDidLoad.asDriver(onErrorJustReturn: ()),
                                        selectedDate: selectedDate.asDriver(onErrorJustReturn: ""),
                                        selectedScheduleIndexPath: tableView.rx.itemSelected.asSignal(),
                                        doneTaps: doneTaps.asSignal(),
                                        updateTaps: updateTaps.asSignal())
        let output = viewModel.transform(input: input)

        output.bookedSchedules.drive(bookedSchedules).disposed(by: disposeBag)
        output.bookedSchedules.drive(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.irisCalendar.configureAppearance()
        }).disposed(by: disposeBag)

        output.result.emit(onNext: { [weak self] (message) in
            guard let strongSelf = self else { return }
            strongSelf.showToast(message: message)
        }).disposed(by: disposeBag)

        output.deleteIndexPath.emit(onNext: { [weak self] (indexPath) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
        }).disposed(by: disposeBag)

        output.updateFixScheduleId.emit(onNext: { (id) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FixScheduleVC") as! FixScheduleVC
            vc.scheduleStatus.onNext(.update(calendarId: id))
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)

        output.updateFixScheduleId.emit(onNext: { (id) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AutoScheduleVC") as! AutoScheduleVC
            vc.scheduleStatus.onNext(.update(calendarId: id))
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)

        output.selectedSchedule.emit(onNext: { [weak self] (schedule) in
            guard let strongSelf = self else { return }
            let alert = UIAlertController(title: schedule.scheduleName, message: nil, preferredStyle: .alert)
            alert.view.tintColor = IrisColor.main

            let update = UIAlertAction(title: "일정 수정하기", style: .default) { (_) in strongSelf.updateTaps.accept(()) }
            let done = UIAlertAction(title: "일정 완료", style: .default) { (_) in strongSelf.doneTaps.accept(()) }

            alert.addAction(update)
            alert.addAction(done)
            strongSelf.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)

        output.dailySchedule.drive(tableView.rx.items(cellIdentifier: "TodayScheduleListCell", cellType: TodayScheduleListCell.self)) {
            $2.configure(info: $1)
        }.disposed(by: disposeBag)

    }

}

extension MainVC: MenubarDelegate {
    func goWhere(destination: GoWhere) {
        switch destination {
        case .none: return
        case .FixScheduleVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: destination.rawValue) as! FixScheduleVC
            vc.scheduleStatus.onNext(.add)
            self.navigationController?.pushViewController(vc, animated: false)
        case .AutoScheduleVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: destination.rawValue) as! AutoScheduleVC
            vc.scheduleStatus.onNext(.add)
            self.navigationController?.pushViewController(vc, animated: false)
        case .AuthNC:
            self.navigationController?.dismiss(animated: false, completion: nil)
            self.presentVC(identifier: destination.rawValue)
        default: self.goNextVC(identifier: destination.rawValue)
        }
    }
}

extension MainVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if dateFormatter.string(from: date) == today {
            todayDateLbl.text = "Today"
        } else {
            todayDateLbl.text = dateFormatter.string(from: date)
        }
        selectedDate.onNext(dateFormatter.string(from: date))
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = dateFormatter.string(from: date)
        guard let category = bookedSchedules.value[key] else { return nil }
        return IrisCategory.getIrisCategory(category: category).getColor()
    }
}

extension MainVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.bubbleColor = UIColor.white.withAlphaComponent(0.5)
        if presented as? MenubarVC != nil { transition.startingPoint = CGPoint(x: 0, y: 0) }
        if presented as? AddScheduleMenubarVC != nil { transition.startingPoint = CGPoint(x: view.frame.width, y: 0) }
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.bubbleColor = UIColor.white.withAlphaComponent(0.5)
        if dismissed as? MenubarVC != nil { transition.startingPoint = CGPoint(x: 0, y: 0) }
        if dismissed as? AddScheduleMenubarVC != nil { transition.startingPoint = CGPoint(x: view.frame.width, y: 0) }
        return transition
    }
}

class TodayScheduleListCell: UITableViewCell {
    @IBOutlet weak var categoryView: RoundView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!

    func configure(info: DailySchedule) {
        categoryView.backgroundColor = info.category.getColor()
        titleLbl.text = info.scheduleName
        timeLbl.text = "\(info.startTime) ~ \(info.endTime)"
    }
}

enum GoWhere: String {
    case none
    case TimeResettingVC
    case EditCategoryVC
    case AuthNC
    case FixScheduleVC
    case AutoScheduleVC
}
