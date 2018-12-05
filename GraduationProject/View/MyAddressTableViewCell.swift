//
//  MyAddressTableViewCell.swift
//  GraduationProject
//
//  Created by Burak Akin on 5.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class MyAddressTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var fullAddressLabel: UILabel!
    @IBOutlet weak var deleteAddressButton: UIButton!
    
    var deleteButtonTapped: ((MyAddressTableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteAddressButton(_ sender: Any) {
        deleteButtonTapped?(self)
    }
}
