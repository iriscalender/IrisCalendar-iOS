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
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}
