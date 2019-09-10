//
//  AddScheduleVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

class AddScheduleVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var purpleBtn: RoundButton!
    @IBOutlet weak var purpleLbl: UILabel!
    @IBOutlet weak var skyblueBtn: RoundButton!
    @IBOutlet weak var skyblueLbl: UILabel!
    @IBOutlet weak var pinkBtn: RoundButton!
    @IBOutlet weak var pinkLbl: UILabel!
    @IBOutlet weak var yellowBtn: RoundButton!
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
