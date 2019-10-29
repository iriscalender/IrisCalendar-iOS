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

extension String {
}

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
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "NanumSquareLight.ttf", size: 10)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    func goNextVC(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}
