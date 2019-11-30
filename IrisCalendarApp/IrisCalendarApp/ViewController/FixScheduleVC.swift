//
//  FixScheduleVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FixScheduleVC: UIViewController {
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
    @IBOutlet weak var setStartTimeBtn: UIButton!
    @IBOutlet weak var setStartTimeLbl: UILabel!
    @IBOutlet weak var setEndTimeBtn: UIButton!
    @IBOutlet weak var setEndTimeLbl: UILabel!

    @IBOutlet weak var purpleBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pinkBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orangeBtnHeightConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()
    private let viewModel = FixScheduleViewModel()
    private let startTime = BehaviorRelay<String>(value: "yyyy-MM-dd HH:mm")
    private let endTime = BehaviorRelay<String>(value: "yyyy-MM-dd HH:mm")

    let scheduleStatus = BehaviorRelay<ScheduleStatus>(value: .unknown)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        let datePickerAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "Korean")
        datePicker.minuteInterval = 10
        datePicker.frame = CGRect(x: 0, y: 30, width: 270, height: 200)
        datePickerAlert.view.addSubview(datePicker)

        let okAction = UIAlertAction(title: "완료", style: .default) { [unowned self] (_) in
            if datePickerAlert.title == "시작시간설정\n\n\n\n\n\n\n\n\n" {
                self.setStartTimeLbl.text = IrisDateFormat.dateAndTime.toString(date: datePicker.date)
                self.startTime.accept(IrisDateFormat.dateAndTime.toString(date: datePicker.date))
            } else {
                self.setEndTimeLbl.text = IrisDateFormat.dateAndTime.toString(date: datePicker.date)
                self.endTime.accept(IrisDateFormat.dateAndTime.toString(date: datePicker.date))
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        datePickerAlert.addAction(okAction)
        datePickerAlert.addAction(cancelAction)

        setStartTimeBtn.rx.tap.asObservable().subscribe(onNext: { [unowned self] (_) in
            datePickerAlert.title = "시작시간설정\n\n\n\n\n\n\n\n\n"
            self.present(datePickerAlert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        setEndTimeBtn.rx.tap.asObservable().subscribe(onNext: { [unowned self] (_) in
            datePickerAlert.title = "종료시간설정\n\n\n\n\n\n\n\n\n"
            self.present(datePickerAlert, animated: true, completion: nil)
        }).disposed(by: disposeBag)

        configureCategory(purple: purpleLbl, blue: blueLbl, pink: pinkLbl, orange: orangeLbl)
        cancelBtn.rx.tap.asObservable().subscribeOn(MainScheduler.instance).subscribe(cancelObserver).disposed(by: disposeBag)
        scheduleNameTxtField.configureIrisEffect(underlineView: scheduleNameUnderlineView, disposeBag: disposeBag)
    }

    private func bindViewModel() {
        let input = FixScheduleViewModel.Input(scheduleStatus: scheduleStatus.asDriver(),
                                               scheduleName: scheduleNameTxtField.rx.text.orEmpty.asDriver(),
                                               startTime: startTime.asDriver(),
                                               endTime: endTime.asDriver(),
                                               purlpleTap: purpleBtn.rx.tap.asSignal(),
                                               blueTap: blueBtn.rx.tap.asSignal(),
                                               pinkTap: pinkBtn.rx.tap.asSignal(),
                                               orangeTap: orangeBtn.rx.tap.asSignal(),
                                               doneTap: doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnabled.drive(onNext: { [unowned self] in self.updateBtnColor(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)

        output.purpleSize.drive(purpleBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.blueSize.drive(blueBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.pinkSize.drive(pinkBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.orangeSize.drive(orangeBtnHeightConstraint.rx.constant).disposed(by: disposeBag)
        output.purpleSize.delay(RxTimeInterval.milliseconds(1)).drive(onNext: { [unowned self] (_) in
            self.updateBtnRadius(btns: [self.purpleBtn, self.blueBtn, self.pinkBtn, self.orangeBtn])
        }).disposed(by: disposeBag)

        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0) },
                           onCompleted: { [unowned self] in self.goPreviousVC() }).disposed(by: disposeBag)
    }

}
