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

    private let loadData = BehaviorRelay<Void>(value: ())
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    private let doneTap = PublishRelay<Void>()
    private let updateTap = PublishRelay<Void>()
    private let today = IrisDateFormat.date.toString(date: Date())
    private let selectedDate = BehaviorSubject<String>(value: IrisDateFormat.date.toString(date: Date()))
    private var bookedSchedules = BehaviorRelay<[String: String]>(value: [:])

    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginCheck()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData.accept(())
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
            print(Token.token)
            print(IrisCategory.shared)
            configureUI()
            bindViewModel()
        }
    }

    private func configureUI() {
        irisCalendar.appearance.titleFont = UIFont(name: "NanumSquareEB", size: 15)
        irisCalendar.appearance.weekdayFont = UIFont(name: "NanumSquareEB", size: 15)
        irisCalendar.appearance.headerTitleFont = UIFont(name: "NanumSquareEB", size: 20)
        irisCalendar.appearance.titleDefaultColor = IrisColor.calendarDefault
        irisCalendar.appearance.weekdayTextColor = IrisColor.calendarTitle
        irisCalendar.appearance.headerTitleColor = IrisColor.calendarTitle
        irisCalendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        irisCalendar.appearance.todayColor = IrisColor.todayColor
        irisCalendar.appearance.selectionColor = IrisColor.calendarDefault
        irisCalendar.delegate = self
        irisCalendar.dataSource = self
    }

    private func bindViewModel() {
        let input = MainViewModel.Input(selectedDate: selectedDate.asSignal(onErrorJustReturn: ""),
                                        selectedScheduleIndexPath: tableView.rx.itemSelected.asSignal(),
                                        loadData: loadData.asSignal(onErrorJustReturn: ()),
                                        doneTap: doneTap.asSignal(),
                                        updateTap: updateTap.asSignal())
        let output = viewModel.transform(input: input)

        output.bookedSchedules.drive(bookedSchedules).disposed(by: disposeBag)
        output.bookedSchedules.drive(onNext: { [unowned self] (_) in self.irisCalendar.reloadData() }).disposed(by: disposeBag)

        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0) }).disposed(by: disposeBag)

        output.selectedFixScheduleID.emit(onNext: { [unowned self] in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FixScheduleVC") as! FixScheduleVC
            vc.scheduleStatus.accept(.update(calendarId: $0))
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)

        output.selectedAutoScheduleID.emit(onNext: { [unowned self] in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AutoScheduleVC") as! AutoScheduleVC
            vc.scheduleStatus.accept(.update(calendarId: $0))
            self.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)

        output.selectedScheduleName.emit(onNext: { [unowned self] in
            let alert = UIAlertController(title: $0, message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = IrisColor.main
            let update = UIAlertAction(title: "일정 수정하기", style: .default) { (_) in self.updateTap.accept(()) }
            let done = UIAlertAction(title: "일정 완료", style: .default) { (_) in self.doneTap.accept(()) }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(update)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)

        output.dailySchedule.drive(tableView.rx.items(cellIdentifier: "TodayScheduleListCell", cellType: TodayScheduleListCell.self)) {
            $2.configure(info: $1)
        }.disposed(by: disposeBag)

        output.dailySchedule.drive(onNext: { [unowned self] (_) in self.irisCalendar.reloadData() }).disposed(by: disposeBag)

    }

}

extension MainVC: MenubarDelegate {
    func goWhere(destination: GoWhere) {
        switch destination {
        case .none: return
        case .FixScheduleVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: destination.rawValue) as! FixScheduleVC
            vc.scheduleStatus.accept(.add)
            self.navigationController?.pushViewController(vc, animated: false)
        case .AutoScheduleVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: destination.rawValue) as! AutoScheduleVC
            vc.scheduleStatus.accept(.add)
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
        if IrisDateFormat.date.toString(date: date) == today {
            todayDateLbl.text = "Today"
        } else {
            todayDateLbl.text = IrisDateFormat.date.toString(date: date)
        }
        selectedDate.onNext(IrisDateFormat.date.toString(date: date))
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = IrisDateFormat.date.toString(date: date)
        guard let category = bookedSchedules.value[key] else { return nil }
        return IrisCategory.Category.toCategory(category: category).toColor()
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let key = IrisDateFormat.date.toString(date: date)
        if key == today { return UIColor.white }
        return bookedSchedules.value[key] == nil ? IrisColor.calendarDefault : UIColor.white
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
        categoryView.backgroundColor = info.category.toColor()
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
