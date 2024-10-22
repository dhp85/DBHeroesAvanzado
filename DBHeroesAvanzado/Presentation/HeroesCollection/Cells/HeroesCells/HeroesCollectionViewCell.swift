//
//  HeroesCollectionViewCell.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 17/10/24.
//

import UIKit

class HeroesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameHeroUILabel: UILabel!
    
    @IBOutlet weak var heroImageView: UIImageView!
    
    static var identifier: String {
        String(describing: HeroesCollectionViewCell.self)
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Agregar borde solo al contentView de la celda
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        // Esquinas redondeadas para el contentView
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
    }
}


