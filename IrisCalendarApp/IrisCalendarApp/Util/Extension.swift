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
                underlineView.backgroundColor = IrisColor.blueCategory
                underlineView.tintColor = IrisColor.blueCategory
                underlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
            })
        }.disposed(by: disposeBag)

        self.rx.controlEvent(.editingDidEnd).subscribe { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                underlineView.backgroundColor = IrisColor.authTxtField
                underlineView.tintColor = IrisColor.authTxtField
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
        navigationController?.pushViewController(vc!, animated: false)
    }

    func presentVC(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: false, completion: nil)
    }

    func updateBtnRadius(btns: [UIButton]) {
        btns.forEach { $0.layer.cornerRadius = $0.frame.height / 2 }
    }

    func updateBtnColor(btn: UIButton, isEnabled: Bool) {
        if isEnabled {
            btn.backgroundColor = IrisColor.mainHalfClear
            btn.setTitleColor(UIColor.white, for: .normal)
        } else {
            btn.backgroundColor = IrisColor.btnIsUnableState
            btn.setTitleColor(UIColor.black, for: .disabled)
        }
    }

    @objc func dismissKeyboard() { self.view.endEditing(true) }

    @objc func keyboardHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension UIColor {
    func hexStringToUIColor(hex:String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0)
        )
    }
}

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
