//
//  AddScheduleMenubarVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 01/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import BubbleTransition

class AddScheduleMenubarVC: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addFixScheduleBtn: UIButton!
    @IBOutlet weak var addAutoScheduleBtn: UIButton!
    weak var interactiveTransition: BubbleInteractiveTransition?

    var delegate: MenubarDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        setUpUI()
    }

    private func setUpUI() {
        addBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.interactiveTransition?.finish()
        }.disposed(by: disposeBag)

        addFixScheduleBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.goWhere(destination: .FixScheduleVC)
            strongSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        addAutoScheduleBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.goWhere(destination: .AutoScheduleVC)
            strongSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

    override var prefersStatusBarHidden: Bool { return true }

}
