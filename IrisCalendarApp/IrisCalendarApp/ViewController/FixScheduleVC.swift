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
    private let fixScheduleViewDidLoad = BehaviorSubject<Void>(value: ())
    private let startTime = BehaviorRelay<String>(value: "yyyy-MM-dd HH:mm")
    private let endTime = BehaviorRelay<String>(value: "yyyy-MM-dd HH:mm")

    let scheduleStatus = PublishSubject<ScheduleStatus>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    private func setUpUI() {
        let datePickerAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "Korean")
        datePicker.minuteInterval = 30
        datePicker.frame = CGRect(x: 0, y: 30, width: 270, height: 200)
        datePickerAlert.view.addSubview(datePicker)

        let okAction = UIAlertAction(title: "완료", style: .default) { [unowned self] (action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if datePickerAlert.title == "시작시간설정\n\n\n\n\n\n\n\n\n" {
                self.setStartTimeLbl.text = dateFormatter.string(from: datePicker.date)
                self.startTime.accept(dateFormatter.string(from: datePicker.date))
            } else {
                self.setEndTimeLbl.text = dateFormatter.string(from: datePicker.date)
                self.endTime.accept(dateFormatter.string(from: datePicker.date))
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        datePickerAlert.addAction(okAction)
        datePickerAlert.addAction(cancelAction)

        cancelBtn.rx.tap.asDriver().drive(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)

        setStartTimeBtn.rx.tap.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            datePickerAlert.title = "시작시간설정\n\n\n\n\n\n\n\n\n"
            strongSelf.present(datePickerAlert, animated: true, completion: nil)
        }).disposed(by: disposeBag)

        setEndTimeBtn.rx.tap.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            datePickerAlert.title = "종료시간설정\n\n\n\n\n\n\n\n\n"
            strongSelf.present(datePickerAlert, animated: true, completion: nil)
        }).disposed(by: disposeBag)

        scheduleNameTxtField.configureIrisEffect(underlineView: scheduleNameUnderlineView, disposeBag: disposeBag)
    }

    private func bindViewModel() {
        let input = FixScheduleViewModel.Input(saveTaps: doneBtn.rx.tap.asSignal(),
                                               scheduleStatus: scheduleStatus.asSignal(onErrorJustReturn: .unknown),
                                               viewDidLoad: fixScheduleViewDidLoad.asSignal(onErrorJustReturn: ()),
                                               purlpleTaps: purpleBtn.rx.tap.asSignal(),
                                               blueTaps: blueBtn.rx.tap.asSignal(),
                                               pinkTaps: pinkBtn.rx.tap.asSignal(),
                                               orangeTaps: orangeBtn.rx.tap.asSignal(),
                                               scheduleName: scheduleNameTxtField.rx.text.orEmpty.asDriver(),
                                               startTime: startTime.asDriver(),
                                               endTime: endTime.asDriver())
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
            print(isEnabled)
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
                output.defaultScheduleName.drive(strongSelf.scheduleNameTxtField.rx.text.asObserver()).disposed(by: strongSelf.disposeBag)
                output.defaultStartTime.drive(strongSelf.setStartTimeLbl.rx.text).disposed(by: strongSelf.disposeBag)
                output.defaultEndTime.drive(strongSelf.setEndTimeLbl.rx.text).disposed(by: strongSelf.disposeBag)
            default: return
            }
        }).disposed(by: disposeBag)
    }

}
