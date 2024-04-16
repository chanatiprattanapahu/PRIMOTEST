//
//  HomeCardCollectionViewCell.swift
//  PRIMOTEST
//
//  Created by gusguz on 14/4/2567 BE.
//

import UIKit

class HomeCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(model: Home.CardItem) {
        titleLabel.text = model.title
    }
}
