//
//  TimeSettingVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 21/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class TimeSettingVC: UIViewController {
    @IBOutlet weak var setStartTimeBtn: UIButton!
    @IBOutlet weak var setEndTimeBtn: UIButton!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: HeightRoundButton!

    private let disposeBag = DisposeBag()
    private let viewModel = TimeSettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setUpUI()
    }

    private func setUpUI() {
        setStartTimeBtn.rx.tap.asObservable().subscribe { [unowned self] (_) in
            self.setStartTimeBtn.setTitleColor(IrisColor.mainHalfClear, for: .normal)
            self.setEndTimeBtn.setTitleColor(IrisColor.lightGray, for: .normal)
        }.disposed(by: disposeBag)
        setEndTimeBtn.rx.tap.asObservable().subscribe { [unowned self] (_) in
            self.setEndTimeBtn.setTitleColor(IrisColor.mainHalfClear, for: .normal)
            self.setStartTimeBtn.setTitleColor(IrisColor.lightGray, for: .normal)
        }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let input = TimeSettingViewModel.Input(selectedTime: datePicker.rx.date.asDriver(),
                                               startTimeTap: setStartTimeBtn.rx.tap.asSignal(),
                                               endTimeTap: setEndTimeBtn.rx.tap.asSignal(),
                                               doneTap: doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.startTime.drive(startTimeLbl.rx.text).disposed(by: disposeBag)
        output.endTime.drive(endTimeLbl.rx.text).disposed(by: disposeBag)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnabled.drive(onNext: { [unowned self] in self.updateBtnColor(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)

        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0) },
                           onCompleted: { [unowned self] in self.presentVC(identifier: "MainNC") }).disposed(by: disposeBag)
    }
}
