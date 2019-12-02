//
//  Shape.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 29/08/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import UIKit

final class Round8View: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 8
    }
}

final class RoundView: UIView {
    override func awakeFromNib() {
        layer.cornerRadius = frame.width / 2
    }
}

final class HeightRoundButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = frame.height / 2
    }
}

final class BorderAndRound8Button: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = IrisColor.mainHalfClear.cgColor
    }

    func update(isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 1
            layer.borderColor = UIColor.white.cgColor
            backgroundColor = IrisColor.mainHalfClear
            setTitleColor(IrisColor.mainHalfClear, for: .normal)
        } else {
            layer.borderWidth = 1
            layer.borderColor = IrisColor.mainHalfClear.cgColor
            backgroundColor = UIColor.white
            setTitleColor(UIColor.white, for: .selected)
        }
    }
}

