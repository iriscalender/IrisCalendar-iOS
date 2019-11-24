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
        setStartTimeBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.setStartTimeBtn.setTitleColor(Color.mainHalfClear, for: .normal)
            strongSelf.setEndTimeBtn.setTitleColor(Color.lightGray, for: .normal)
        }.disposed(by: disposeBag)

        setEndTimeBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.setEndTimeBtn.setTitleColor(Color.mainHalfClear, for: .normal)
            strongSelf.setStartTimeBtn.setTitleColor(Color.lightGray, for: .normal)
        }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let input = TimeSettingViewModel.Input(timeSettingTaps: doneBtn.rx.tap.asSignal(),
                                               startTimeTaps: setStartTimeBtn.rx.tap.asSignal(),
                                               endTimeTaps: setEndTimeBtn.rx.tap.asSignal(),
                                               selectedTime: datePicker.rx.date.asDriver())
        let output = viewModel.transform(input: input)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.startTime.drive(startTimeLbl.rx.text).disposed(by: disposeBag)
        output.endTime.drive(endTimeLbl.rx.text).disposed(by: disposeBag)

        output.isEnabled.drive(onNext: { [weak self] (result) in
            guard let strongSelf = self else { return }
            if result {
                strongSelf.doneBtn.backgroundColor = Color.mainHalfClear
                strongSelf.doneBtn.setTitleColor(UIColor.white, for: .normal)
            } else {
                strongSelf.doneBtn.backgroundColor = Color.btnIsEnableState
                strongSelf.doneBtn.setTitleColor(UIColor.black, for: .disabled)
            }
        }).disposed(by: disposeBag)

        output.result.drive (onNext: { [weak self] (message) in
            guard let strongSelf = self else { return }
            strongSelf.showToast(message: message)
            }, onCompleted: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.goNextVC(identifier: "MainVC")
        }).disposed(by: disposeBag)
    }
}
