//
//  HeroesCollectionViewCell.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 17/10/24.
//

import UIKit

class HeroesCollectionViewCell: UICollectionViewCell {

    static var identifier: String {
        String(describing: HeroesCollectionViewCell.self)
    }
    
    @IBOutlet weak var nameHeroUILabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
