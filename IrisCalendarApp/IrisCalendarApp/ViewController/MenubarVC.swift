//
//  MenubarVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import BubbleTransition
import RxSwift
import RxCocoa

class MenubarVC: UIViewController {

    @IBOutlet weak var menuBtnBackgroundView: RoundView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var timeResettingBtn: UIButton!
    @IBOutlet weak var editCategoryBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    weak var interactiveTransition: BubbleInteractiveTransition?

    var delegate: MenubarDelegate?

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        setUpUI()
    }

    private func setUpUI() {
        menuBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.interactiveTransition?.finish()
        }.disposed(by: disposeBag)

        timeResettingBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.goWhere(destination: .TimeResettingVC)
            strongSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        editCategoryBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.goWhere(destination: .EditCategoryVC)
            strongSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        logoutBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            Token.token = nil
            strongSelf.delegate?.goWhere(destination: .AuthNC)
            strongSelf.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

    override var prefersStatusBarHidden: Bool { return true }

}
