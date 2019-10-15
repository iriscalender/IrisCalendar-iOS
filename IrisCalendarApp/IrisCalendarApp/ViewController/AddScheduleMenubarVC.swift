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
    @IBOutlet weak var addScheduleBtn: UIButton!
    weak var interactiveTransition: BubbleInteractiveTransition?

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
    }

    override var prefersStatusBarHidden: Bool { return true }

    @IBAction func addBtnAction(_ sender: UIButton) {

    }

}
