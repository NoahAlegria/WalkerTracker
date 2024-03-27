//
//  PharmaTableViewCell.swift
//  walkerTracker
//
//  Created by user144566 on 11/14/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PharmaTableViewCell: UITableViewCell {

    @IBOutlet weak var addressField: UILabel!
    @IBOutlet weak var hoursField: UILabel!
    @IBOutlet weak var etaField: UILabel!
    @IBOutlet weak var addressPic: UIImageView!
    @IBOutlet weak var hoursPic: UIImageView!
    @IBOutlet weak var etaPic: UIImageView!
    @IBOutlet weak var addressHeader: UILabel!
    @IBOutlet weak var etaHeader: UILabel!
    @IBOutlet weak var hoursHeader: UILabel!
    override func awakeFromNib() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
