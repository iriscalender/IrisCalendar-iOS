//
//  AddScheduleVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AutoScheduleVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var purpleBtn: HeightRoundButton!
    @IBOutlet weak var purpleLbl: UILabel!
    @IBOutlet weak var skyblueBtn: HeightRoundButton!
    @IBOutlet weak var skyblueLbl: UILabel!
    @IBOutlet weak var pinkBtn: HeightRoundButton!
    @IBOutlet weak var pinkLbl: UILabel!
    @IBOutlet weak var yellowBtn: HeightRoundButton!
    @IBOutlet weak var yellowLbl: UILabel!
    
    @IBOutlet weak var scheduleNameTxtField: UITextField!
    @IBOutlet weak var scheduleNameUnderlineView: UIView!
    
    @IBOutlet weak var endYearTxtField: UITextField!
    @IBOutlet weak var endYearUnderlineView: UIView!
    @IBOutlet weak var endMonthTxtField: UITextField!
    @IBOutlet weak var endMonthUnderlineView: UIView!
    @IBOutlet weak var endDayTxtField: UITextField!
    @IBOutlet weak var endDayUnderlineView: UIView!
    
    @IBOutlet weak var theTimeRequiredTxtField: UITextField!
    @IBOutlet weak var theTimeRequiredUnderlineView: UIView!
    @IBOutlet weak var moreImportantScheduleBtn: BorderAndRound8Button!
    
    @IBOutlet weak var theTimeRequiredLbl: UILabel!
    @IBOutlet weak var theTimeRequiredView: UIView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
