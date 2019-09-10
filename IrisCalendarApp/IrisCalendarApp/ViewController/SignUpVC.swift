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

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    @IBOutlet weak var reTypeTxtField: UITextField!
    
    @IBOutlet weak var idUnderlineView: UIView!
    @IBOutlet weak var pwUnderlineView: UIView!
    @IBOutlet weak var reTypeUnderlineView: UIView!
    
    @IBOutlet weak var doneBtn: RoundButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldEffectActivation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    private func txtFieldEffectActivation() {
        idTxtField.rx.controlEvent(.editingDidBegin).subscribe { [unowned self] (_) in
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.idUnderlineView.backgroundColor = Color.main
                self.idUnderlineView.tintColor = Color.main
            })
            }.disposed(by: disposeBag)
        
        idTxtField.rx.controlEvent(.editingDidEnd).subscribe { [unowned self] (_) in
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.idUnderlineView.backgroundColor = Color.authTxtField
                self.idUnderlineView.tintColor = Color.authTxtField
            })
            }.disposed(by: disposeBag)
        
        pwTxtField.rx.controlEvent(.editingDidBegin).subscribe { [unowned self] (_) in
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.pwUnderlineView.backgroundColor = Color.main
                self.pwUnderlineView.tintColor = Color.main
            })
            }.disposed(by: disposeBag)
        
        pwTxtField.rx.controlEvent(.editingDidEnd).subscribe { [unowned self] (_) in
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.pwUnderlineView.backgroundColor = Color.authTxtField
                self.pwUnderlineView.tintColor = Color.authTxtField
            })
            }.disposed(by: disposeBag)
        
        reTypeTxtField.rx.controlEvent(.editingDidBegin).subscribe { [unowned self] (_) in
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.pwUnderlineView.backgroundColor = Color.main
                self.pwUnderlineView.tintColor = Color.main
            })
            }.disposed(by: disposeBag)
        
        reTypeTxtField.rx.controlEvent(.editingDidEnd).subscribe { [unowned self] (_) in
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.pwUnderlineView.backgroundColor = Color.authTxtField
                self.pwUnderlineView.tintColor = Color.authTxtField
            })
            }.disposed(by: disposeBag)
    }
}
