//
//  MyAccountCustomTableViewCell.swift
//  GraduationProject
//
//  Created by Burak Akin on 13.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class MyAccountCustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var myAccountImageView: UIImageView!
    @IBOutlet weak var myAccountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


