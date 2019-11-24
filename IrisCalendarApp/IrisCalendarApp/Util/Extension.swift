//
//  Extension.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/22.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Toaster

extension UITextField {
    func configureIrisEffect(underlineView: UIView, disposeBag: DisposeBag) {

        self.rx.controlEvent(.editingDidBegin).subscribe { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                underlineView.backgroundColor = Color.skyblueCategory
                underlineView.tintColor = Color.skyblueCategory
                underlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
            })
        }.disposed(by: disposeBag)

        self.rx.controlEvent(.editingDidEnd).subscribe { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                underlineView.backgroundColor = Color.authTxtField
                underlineView.tintColor = Color.authTxtField
                underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            })
        }.disposed(by: disposeBag)
    }
}

extension UIViewController {

    func showToast(message: String) {
        Toast(text: message, duration: 1.0).show()
    }

    func goNextVC(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        vc?.modalPresentationStyle = .fullScreen
        if let controller = navigationController {
            controller.pushViewController(vc!, animated: false)
        }
    }

    func updateBtnRadius(btns: [UIButton]) {
        btns.forEach { (btn) in
            btn.layer.cornerRadius = btn.frame.height / 2
        }
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc func keyboardHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
