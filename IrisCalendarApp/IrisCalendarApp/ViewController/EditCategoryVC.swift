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
    @IBOutlet weak var skyblueBtn: HeightRoundButton!
    @IBOutlet weak var skyblueTxtView: UITextView!
    @IBOutlet weak var pinkBtn: HeightRoundButton!
    @IBOutlet weak var pinkTxtView: UITextView!
    @IBOutlet weak var yellowBtn: HeightRoundButton!
    @IBOutlet weak var yellowTxtField: UITextView!

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        cancelBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}
