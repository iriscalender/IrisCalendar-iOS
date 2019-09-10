//
//  MainVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 23/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

import FSCalendar

class MainVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addScheduleBtn: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var todayDateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

class TodayScheduleListCell: UITableViewCell {
    @IBOutlet weak var categoryView: RoundView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
}
