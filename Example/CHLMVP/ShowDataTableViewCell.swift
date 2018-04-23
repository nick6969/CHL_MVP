//
//  ShowDataTableViewCell.swift
//  CHLMVP_Example
//
//  Created by Nick Lin on 2018/4/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class ShowDataTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!

    func setup(with model: ChurchModel) {
        label.text = model.chrName + "\n" + model.chrAddress
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
