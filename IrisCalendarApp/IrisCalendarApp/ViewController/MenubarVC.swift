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

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
    }

    override var prefersStatusBarHidden: Bool { return true }

}
