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
        configureTxtFields(txtFields: [idTxtField, pwTxtField],
                          underlineViews: [idUnderlineView, pwUnderlineView],
                          disposeBag: disposeBag)
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    private func bindViewModel() {
        let input = SignInViewModel.Input(userID: idTxtField.rx.text.orEmpty.asDriver(),
                                          userPW: pwTxtField.rx.text.orEmpty.asDriver(),
                                          doneTap: doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnabled.drive(onNext: { [unowned self] in self.updateBtnColorWithBackground(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)

        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0) },
                           onCompleted: { [unowned self] in self.presentVC(identifier: "MainNC") }).disposed(by: disposeBag)
    }
}
