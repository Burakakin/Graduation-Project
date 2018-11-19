//
//  ProductPageTableViewCell.swift
//  GraduationProject
//
//  Created by Burak Akin on 20.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class ProductPageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productDimensionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var producImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
