//
//  HeroesCollectionViewCell.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 17/10/24.
//

import UIKit

/// Clase que representa una celda personalizada en una colección de héroes.
class HeroesCollectionViewCell: UICollectionViewCell {
    
    /// Etiqueta que muestra el nombre del héroe.
    @IBOutlet weak var nameHeroUILabel: UILabel!
    
    /// Imagen que representa al héroe.
    @IBOutlet weak var heroImageView: UIImageView!
    
    /// Identificador estático para reutilizar la celda en la colección.
    static var identifier: String {
        String(describing: HeroesCollectionViewCell.self)
    }
    
    /// Método que se llama después de que la celda ha sido cargada desde el archivo NIB.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configura el borde del contentView de la celda.
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        // Configura las esquinas redondeadas del contentView.
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
    }
}
