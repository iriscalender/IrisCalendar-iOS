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
        let input = SignUpViewModel.Input(signUpTaps: doneBtn.rx.tap.asSignal(),
                                          id: idTxtField.rx.text.orEmpty.asDriver(),
                                          pw: pwTxtField.rx.text.orEmpty.asDriver(),
                                          rePW: rePWTxtField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)
        
        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        
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
        
        output.result.drive(onNext: { [weak self] (message) in
            guard let strongSelf = self else { return }
            if message == "성공" { strongSelf.goNextVC(identifier: "TimeSettingVC"); return }
            if message.isEmpty { strongSelf.showToast(message: "회원가입실패"); return }
            strongSelf.showToast(message: message)
        }).disposed(by: disposeBag)
    }
}
