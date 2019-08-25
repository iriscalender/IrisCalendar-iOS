//
//  SignInVC.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 21/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var pwTxtField: UITextField!
    
    @IBOutlet weak var idUnderlineView: UIView!
    @IBOutlet weak var pwUnderlineView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func doneBtnAction(_ sender: UIButton) {
    }
    
}
