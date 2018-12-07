//
//  FavouritesTableViewCell.swift
//  GraduationProject
//
//  Created by Burak Akin on 7.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var favouritesProductImageView: UIImageView!
    @IBOutlet weak var favouritesProductNameLabel: UILabel!
    @IBOutlet weak var favouritesProductDescriptionLabel: UILabel!
    @IBOutlet weak var favouritesProductPriceLabel: UILabel!
    
    @IBOutlet weak var favouritesProductDimensionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
