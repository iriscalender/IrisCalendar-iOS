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

        output.result.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let result = event.element else { return }
            if result == "성공" { strongSelf.goNextVC(identifier: "MainVC") }
            if result == "" { strongSelf.showToast(message: "할당시간 설정 실패") }
            strongSelf.showToast(message: result)
        }.disposed(by: disposeBag)

    }
}
