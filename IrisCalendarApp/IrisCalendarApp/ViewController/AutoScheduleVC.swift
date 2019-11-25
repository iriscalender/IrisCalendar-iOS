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

    let scheduleStatus = PublishSubject<ScheduleStatus>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    private func setUpUI() {
        cancelBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)

        moreImportantScheduleBtn.rx.tap.asDriver().drive(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if strongSelf.moreImportantScheduleBtn.isSelected {
                strongSelf.moreImportantScheduleBtn.update(isSelected: false)
                strongSelf.isMoreImportant.accept(false)
                strongSelf.moreImportantScheduleBtn.isSelected = false
            } else {
                strongSelf.moreImportantScheduleBtn.update(isSelected: true)
                strongSelf.isMoreImportant.accept(true)
                strongSelf.moreImportantScheduleBtn.isSelected = true
            }
        }).disposed(by: disposeBag)

        scheduleNameTxtField.configureIrisEffect(underlineView: scheduleNameUnderlineView, disposeBag: disposeBag)
        endYearTxtField.configureIrisEffect(underlineView: endYearUnderlineView, disposeBag: disposeBag)
        endMonthTxtField.configureIrisEffect(underlineView: endMonthUnderlineView, disposeBag: disposeBag)
        endDayTxtField.configureIrisEffect(underlineView: endDayUnderlineView, disposeBag: disposeBag)
        theTimeRequiredTxtField.configureIrisEffect(underlineView: theTimeRequiredUnderlineView, disposeBag: disposeBag)
    }

    private func bindViewModel() {
        let input = AutoScheduleViewModel.Input(saveTaps: doneBtn.rx.tap.asSignal(),
                                                scheduleStatus: scheduleStatus.asSignal(onErrorJustReturn: .unknown),
                                                viewDidLoad: autoScheduleViewDidLoad.asSignal(onErrorJustReturn: ()),
                                                purlpleTaps: purpleBtn.rx.tap.asSignal(),
                                                blueTaps: blueBtn.rx.tap.asSignal(),
                                                pinkTaps: pinkBtn.rx.tap.asSignal(),
                                                orangeTaps: orangeBtn.rx.tap.asSignal(),
                                                scheduleName: scheduleNameTxtField.rx.text.orEmpty.asDriver(),
                                                endYear: endYearTxtField.rx.text.orEmpty.asDriver(),
                                                endMonth: endMonthTxtField.rx.text.orEmpty.asDriver(),
                                                endDay: endDayTxtField.rx.text.orEmpty.asDriver(),
                                                theTimeRequired: theTimeRequiredTxtField.rx.text.orEmpty.asDriver(),
                                                isMoreImportant: isMoreImportant.asDriver())
        let output = viewModel.transform(input: input)

        output.purpleTxt.drive(purpleLbl.rx.text).disposed(by: disposeBag)
        output.blueTxt.drive(blueLbl.rx.text).disposed(by: disposeBag)
        output.pinkTxt.drive(pinkLbl.rx.text).disposed(by: disposeBag)
        output.orangeTxt.drive(orangeLbl.rx.text).disposed(by: disposeBag)
        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)

        output.purpleSize.drive(purpleBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.blueSize.drive(blueBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.pinkSize.drive(pinkBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.orangeSize.drive(orangeBtnHeightConstraint.rx.constant).disposed(by: disposeBag)

        output.isEnabled.drive(onNext: { [weak self] (isEnabled) in
            guard let strongSelf = self else { return }
            if isEnabled {
                strongSelf.doneBtn.setTitleColor(UIColor.white, for: .normal)
            } else {
                strongSelf.doneBtn.setTitleColor(Color.main, for: .disabled)
            }
        }).disposed(by: disposeBag)

        output.purpleSize.delay(RxTimeInterval.milliseconds(1)).drive(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.updateBtnRadius(btns: [strongSelf.purpleBtn, strongSelf.blueBtn, strongSelf.pinkBtn, strongSelf.orangeBtn])
        }).disposed(by: disposeBag)

        output.result.drive(onNext: { [weak self] (message) in
            guard let strongSelf = self else { return }
            strongSelf.showToast(message: message)
            }, onCompleted: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

        scheduleStatus.asDriver(onErrorJustReturn: .unknown).drive(onNext: { [weak self] (status) in
            guard let strongSelf = self else { return }
            switch status {
            case .update:
                output.defaultScheduleName.drive(strongSelf.scheduleNameTxtField.rx.text).disposed(by: strongSelf.disposeBag)
                output.defaultEndYear.drive(strongSelf.endYearTxtField.rx.text).disposed(by: strongSelf.disposeBag)
                output.defaultEndMonth.drive(strongSelf.endMonthTxtField.rx.text).disposed(by: strongSelf.disposeBag)
                output.defaultEndDay.drive(strongSelf.endDayTxtField.rx.text).disposed(by: strongSelf.disposeBag)
                output.defaultTheTimeRequired.drive(strongSelf.theTimeRequiredTxtField.rx.text).disposed(by: strongSelf.disposeBag)
                output.deaultIsMoreImportant.drive(strongSelf.moreImportantScheduleBtn.rx.isSelected).disposed(by: strongSelf.disposeBag)
                output.deaultIsMoreImportant.drive(onNext: { strongSelf.isMoreImportant.accept($0) }).disposed(by: strongSelf.disposeBag)
            default: return
            }
        }).disposed(by: disposeBag)
    }
}
