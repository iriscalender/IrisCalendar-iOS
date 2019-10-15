//
//  XibView.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

class XibView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    func initUI() { }
}
