//
//  ShoppingCardTableViewCell.swift
//  GraduationProject
//
//  Created by Burak Akin on 1.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class ShoppingCardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var shoppingCardProductImageView: UIImageView!
    @IBOutlet weak var shoppingCardProductName: UILabel!
    @IBOutlet weak var shoppingCardProductDescription: UILabel!
    @IBOutlet weak var shoppingCardProductSeller: UILabel!
    @IBOutlet weak var shoppingCardDeleteButton: UIButton!
    
    @IBOutlet weak var shoppingCardProductPrice: UILabel!
    @IBOutlet weak var shoppingCardMinusButton: UIButton!
    @IBOutlet weak var shoppingCardPieceLabel: UILabel!
    @IBOutlet weak var shoppingCardPlusButton: UIButton!
    
    var PlusButtonTapped: ((ShoppingCardTableViewCell) -> Void)?
    var MinusButtonTapped: ((ShoppingCardTableViewCell) -> Void)?
    var DeleteButtonTapped: ((ShoppingCardTableViewCell) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func plusButton(_ sender: Any) {
        PlusButtonTapped?(self)
    }
    @IBAction func minusButton(_ sender: Any) {
        MinusButtonTapped?(self)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        DeleteButtonTapped?(self)
    }
}
