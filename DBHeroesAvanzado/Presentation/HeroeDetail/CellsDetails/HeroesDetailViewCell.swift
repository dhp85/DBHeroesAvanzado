//
//  HeroesDetailViewCell.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 24/10/24.
//

import UIKit

class HeroesDetailViewCell: UICollectionViewCell {
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var imageHero: UIImageView!
    
    static var identifier: String {
        return String(describing:HeroesDetailViewCell.self)
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
