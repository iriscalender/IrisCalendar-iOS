//
//  SignUpVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 21/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var rePWTxtField: UITextField!
    @IBOutlet weak var idUnderlineView: UIView!
    @IBOutlet weak var pwUnderlineView: UIView!
    @IBOutlet weak var rePWUnderlineView: UIView!
    @IBOutlet weak var doneBtn: HeightRoundButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setUpUI() {
        idTxtField.configureIrisEffect(underlineView: idUnderlineView, disposeBag: disposeBag)
        pwTxtField.configureIrisEffect(underlineView: pwUnderlineView, disposeBag: disposeBag)
        rePWTxtField.configureIrisEffect(underlineView: rePWUnderlineView, disposeBag: disposeBag)
    }
    
    private func bindViewModel() {
        let input = SignUpViewModel.Input(id: idTxtField.rx.text.orEmpty.asDriver(),
                                          pw: pwTxtField.rx.text.orEmpty.asDriver(),
                                          rePW: rePWTxtField.rx.text.orEmpty.asDriver(),
                                          doneTaps: doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnabled.drive(onNext: { [unowned self] in self.updateBtnColor(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)
        
        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0)},
                           onCompleted: { [unowned self] in self.presentVC(identifier: "TimeSettingVC") }).disposed(by: disposeBag)
    }
}
