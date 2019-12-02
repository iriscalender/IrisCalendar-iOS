//
//  AddScheduleVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AutoScheduleVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var purpleBtn: HeightRoundButton!
    @IBOutlet weak var purpleLbl: UILabel!
    @IBOutlet weak var blueBtn: HeightRoundButton!
    @IBOutlet weak var blueLbl: UILabel!
    @IBOutlet weak var pinkBtn: HeightRoundButton!
    @IBOutlet weak var pinkLbl: UILabel!
    @IBOutlet weak var orangeBtn: HeightRoundButton!
    @IBOutlet weak var orangeLbl: UILabel!

    @IBOutlet weak var scheduleNameTxtField: UITextField!
    @IBOutlet weak var scheduleNameUnderlineView: UIView!
    @IBOutlet weak var endYearTxtField: UITextField!
    @IBOutlet weak var endYearUnderlineView: UIView!
    @IBOutlet weak var endMonthTxtField: UITextField!
    @IBOutlet weak var endMonthUnderlineView: UIView!
    @IBOutlet weak var endDayTxtField: UITextField!
    @IBOutlet weak var endDayUnderlineView: UIView!
    @IBOutlet weak var theTimeRequiredTxtField: UITextField!
    @IBOutlet weak var theTimeRequiredUnderlineView: UIView!
    @IBOutlet weak var moreImportantScheduleBtn: BorderAndRound8Button!
    @IBOutlet weak var theTimeRequiredLbl: UILabel!
    @IBOutlet weak var theTimeRequiredView: UIView!

    @IBOutlet weak var purpleBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pinkBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orangeBtnHeightConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()
    private let viewModel = AutoScheduleViewModel()
    private let autoScheduleViewDidLoad = BehaviorSubject<Void>(value: ())
    private let isMoreImportant = BehaviorRelay<Bool>(value: false)

    let scheduleStatus = BehaviorRelay<ScheduleStatus>(value: .unknown)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        scheduleStatus.subscribe(onNext: { [unowned self] (scheduleStatus) in
            switch scheduleStatus {
            case .update: self.titleLbl.text = "자동관리일정 수정하기"
            default: return
            }
        }).disposed(by: disposeBag)
        cancelBtn.rx.tap.asObservable().subscribe(cancelObserver).disposed(by: disposeBag)

        moreImportantScheduleBtn.rx.tap.asDriver().drive(onNext: { [unowned self] (_) in
            self.updateMoreImporatnt(isSelcted: !self.moreImportantScheduleBtn.isSelected)
        }).disposed(by: disposeBag)

        configureCategory(purple: purpleLbl, blue: blueLbl, pink: pinkLbl, orange: orangeLbl)

        configureTxtFields(txtFields: [scheduleNameTxtField, endYearTxtField, endMonthTxtField, endDayTxtField, theTimeRequiredTxtField],
                           underlineViews: [scheduleNameUnderlineView, endYearUnderlineView, endMonthUnderlineView, endDayUnderlineView, theTimeRequiredUnderlineView],
                           disposeBag: disposeBag)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func bindViewModel() {
        let input = AutoScheduleViewModel.Input(scheduleStatus: scheduleStatus.asDriver(),
                                                scheduleName: scheduleNameTxtField.rx.text.orEmpty.asDriver(),
                                                endYear: endYearTxtField.rx.text.orEmpty.asDriver(),
                                                endMonth: endMonthTxtField.rx.text.orEmpty.asDriver(),
                                                endDay: endDayTxtField.rx.text.orEmpty.asDriver(),
                                                theTimeRequired: theTimeRequiredTxtField.rx.text.orEmpty.asDriver(),
                                                isMoreImportant: isMoreImportant.asDriver(),
                                                purlpleTap: purpleBtn.rx.tap.asSignal(),
                                                blueTap: blueBtn.rx.tap.asSignal(),
                                                pinkTap: pinkBtn.rx.tap.asSignal(),
                                                orangeTap: orangeBtn.rx.tap.asSignal(),
                                                doneTap: doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.purpleSize.drive(purpleBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.blueSize.drive(blueBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.pinkSize.drive(pinkBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.orangeSize.drive(orangeBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.purpleSize.delay(RxTimeInterval.milliseconds(1)).drive(onNext: { [unowned self] (_) in
            self.updateBtnRadius(btns: [self.purpleBtn, self.blueBtn, self.pinkBtn, self.orangeBtn])
        }).disposed(by: disposeBag)

        output.defaultScheduleName.drive(scheduleNameTxtField.rx.text).disposed(by: disposeBag)
        output.defaultEndYear.drive(endYearTxtField.rx.text).disposed(by: disposeBag)
        output.defaultEndMonth.drive(endMonthTxtField.rx.text).disposed(by: disposeBag)
        output.defaultEndDay.drive(endDayTxtField.rx.text).disposed(by: disposeBag)
        output.defaultTheTimeRequired.drive(theTimeRequiredTxtField.rx.text).disposed(by: disposeBag)
        output.defaultIsMoreImportant.drive(onNext: { [unowned self] in self.updateBtnColor(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)
        output.defaultIsMoreImportant.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnabled.drive(onNext: { [unowned self] in self.updateBtnColor(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)

        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0) },
                           onCompleted: { [unowned self] in self.goPreviousVC() }).disposed(by: disposeBag)
    }

    private func updateMoreImporatnt(isSelcted: Bool) {
        moreImportantScheduleBtn.update(isSelected: isSelcted)
        isMoreImportant.accept(isSelcted)
        moreImportantScheduleBtn.isSelected = isSelcted
    }

    @objc func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && !self.theTimeRequiredTxtField.isFirstResponder {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
}
