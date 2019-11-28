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
    
    private let disposeBag = DisposeBag()
    private let viewModel = SignInViewModel()
    
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
        let input = SignInViewModel.Input(SignInTaps: doneBtn.rx.tap.asSignal(),
                                          id: idTxtField.rx.text.orEmpty.asDriver(),
                                          pw: pwTxtField.rx.text.orEmpty.asDriver())
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

        output.result.drive(onNext: { [weak self] (result) in
            guard let strongSelf = self else { return }
            if result == "성공" { strongSelf.presentVC(identifier: "MainNC"); return }
            strongSelf.showToast(message: result)
        }).disposed(by: disposeBag)
    }
    
}
