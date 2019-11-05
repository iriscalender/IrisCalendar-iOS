//
//  TimeResettingVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class TimeResettingVC: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var setStartTimeBtn: UIButton!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var setEndTimeBtn: UIButton!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: HeightRoundButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel = TimeResettingViewModel()
    private let timeResettingViewDidLoad = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeResettingViewDidLoad.onNext(())
        setUpUI()
        bindViewModel()
    }

    private func setUpUI() {
        cancelBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let input = TimeResettingViewModel.Input(timeSettingTaps: doneBtn.rx.tap.asSignal(),
                                                 viewDidLoad: timeResettingViewDidLoad.asSignal(onErrorJustReturn: ()),
                                                 startTimeTaps: setStartTimeBtn.rx.tap.asSignal(),
                                                 endTimeTaps: setEndTimeBtn.rx.tap.asSignal(),
                                                 selectedTime: datePicker.rx.date.asDriver())
        let output = viewModel.transform(input: input)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.startTime.drive(startTimeLbl.rx.text).disposed(by: disposeBag)
        output.endTime.drive(endTimeLbl.rx.text).disposed(by: disposeBag)

        output.isEnabled.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            if event.element == true {
                strongSelf.doneBtn.backgroundColor = Color.mainHalfClear
                strongSelf.doneBtn.setTitleColor(UIColor.white, for: .normal)
            } else {
                strongSelf.doneBtn.backgroundColor = Color.btnIsEnableState
                strongSelf.doneBtn.setTitleColor(UIColor.black, for: .disabled)
            }
        }.disposed(by: disposeBag)

        output.result.drive(onNext: { [weak self] (message) in
            guard let strongSelf = self else { return }
            switch message {
            case "":
                strongSelf.showToast(message: "할당시간 설정 실패")
            case "불러오기 성공":
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                output.startTime.drive(onNext: { (time) in
                    strongSelf.datePicker.date = formatter.date(from: time)!
                }).disposed(by: strongSelf.disposeBag)
            default:
                strongSelf.showToast(message: message)
            }
            }, onCompleted: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
}
