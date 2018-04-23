//
//  ChurchModel.swift
//  CHLMVP_Example
//
//  Created by Nick Lin on 2018/4/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import CHLMVP

struct ChurchModel: JsonModel {
    let chrName, chrAddress: String
    enum CodingKeys: String, CodingKey {
        case chrName = "CHR_Name"
        case chrAddress = "CHR_Address"
    }
}

