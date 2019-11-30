//
//  EditCategoryVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class EditCategoryVC: UIViewController {
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var purpleBtn: HeightRoundButton!
    @IBOutlet weak var purpleTxtView: UITextView!
    @IBOutlet weak var blueBtn: HeightRoundButton!
    @IBOutlet weak var blueTxtView: UITextView!
    @IBOutlet weak var pinkBtn: HeightRoundButton!
    @IBOutlet weak var pinkTxtView: UITextView!
    @IBOutlet weak var orangeBtn: HeightRoundButton!
    @IBOutlet weak var orangeTxtView: UITextView!

    private let disposeBag = DisposeBag()
    private let viewModel = EditCategoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        cancelBtn.rx.tap.asObservable().subscribe(cancelObserver).disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let input = EditCategoryViewModel.Input(loadData: Completable.empty(),
                                                purpleTxt: purpleTxtView.rx.text.orEmpty.asDriver(),
                                                blueTxt: blueTxtView.rx.text.orEmpty.asDriver(),
                                                pinkTxt: pinkTxtView.rx.text.orEmpty.asDriver(),
                                                orangeTxt: orangeTxtView.rx.text.orEmpty.asDriver(),
                                                doneTap: doneBtn.rx.tap.asSignal())
        let output = viewModel.transform(input: input)

        output.purpleTxt.drive(purpleTxtView.rx.text).disposed(by: disposeBag)
        output.blueTxt.drive(blueTxtView.rx.text).disposed(by: disposeBag)
        output.pinkTxt.drive(pinkTxtView.rx.text).disposed(by: disposeBag)
        output.orangeTxt.drive(orangeTxtView.rx.text).disposed(by: disposeBag)

        output.isEnabled.drive(doneBtn.rx.isEnabled).disposed(by: disposeBag)
        output.isEnabled.drive(onNext: { [unowned self] in self.updateBtnColor(btn: self.doneBtn, isEnabled: $0) }).disposed(by: disposeBag)

        output.result.emit(onNext: { [unowned self] in self.showToast(message: $0) },
                           onCompleted: { [unowned self] in self.goPreviousVC() }).disposed(by: disposeBag)
    }

    @objc func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && !self.purpleTxtView.isFirstResponder && !self.blueTxtView.isFirstResponder {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
}
