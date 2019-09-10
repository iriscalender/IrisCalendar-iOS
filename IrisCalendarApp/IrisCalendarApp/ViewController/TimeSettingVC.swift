//
//  TimeSettingVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 21/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

class TimeSettingVC: UIViewController {

    @IBOutlet weak var setStartTimeBtn: UIButton!
    @IBOutlet weak var setEndTimeBtn: UIButton!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var doneBtn: RoundButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
