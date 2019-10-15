//
//  ViewModelType.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 08/10/2019.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
