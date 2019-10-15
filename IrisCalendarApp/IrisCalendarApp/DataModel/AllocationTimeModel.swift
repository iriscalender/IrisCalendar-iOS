//
//  AllocationTimeModel.swift
//  IrisCalendarApp
//
//  Created by baby1234 on 2019/10/15.
//  Copyright © 2019 baby1234. All rights reserved.
//

import Foundation

struct AllocationTimeModel: Codable {
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case startTime = "start"
        case endTime = "end"
    }
}
