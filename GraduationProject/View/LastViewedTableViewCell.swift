//
//  LastViewedTableViewCell.swift
//  GraduationProject
//
//  Created by Burak Akin on 7.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class LastViewedTableViewCell: UITableViewCell {

    @IBOutlet weak var lastViewedProductImageView: UIImageView!
    @IBOutlet weak var lastViewedProductName: UILabel!
    @IBOutlet weak var lastViewedProductDescription: UILabel!
    @IBOutlet weak var lastViewedProductPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
