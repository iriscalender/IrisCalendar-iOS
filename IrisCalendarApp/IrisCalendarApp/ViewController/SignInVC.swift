//
//  SignInVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 21/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SignInVC: UIViewController {
    
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    
    @IBOutlet weak var idUnderlineView: UIView!
    @IBOutlet weak var pwUnderlineView: UIView!
    
    @IBOutlet weak var doneBtn: HeightRoundButton!
    
    let disposeBag = DisposeBag()
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    private func setUpUI() {
        idTxtField.configureIrisEffect(underlineView: idUnderlineView, disposeBag: disposeBag)
        pwTxtField.configureIrisEffect(underlineView: pwUnderlineView, disposeBag: disposeBag)
    }

    private func bindViewModel() {
        let input = SignInViewModel.Input(loginTaps: doneBtn.rx.tap.asSignal(),
                                          id: idTxtField.rx.text.orEmpty.asDriver(),
                                          pw: pwTxtField.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)

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

        output.result.asObservable().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let result = event.element else { return }
            if result == "성공" { strongSelf.goNextVC(identifier: "TimeSettingVC"); return }
            if result.isEmpty { strongSelf.showToast(message: "회원가입실패"); return }
            strongSelf.showToast(message: result)
        }.disposed(by: disposeBag)
    }
    
}
