//
//  HeroesDetailViewCell.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 24/10/24.
//

import UIKit

/// Clase que representa una celda personalizada en una colección de héroes.
/// Esta celda muestra el nombre y la imagen de un héroe.
class HeroesDetailViewCell: UICollectionViewCell {
    
    /// Etiqueta para mostrar el nombre del héroe.
    @IBOutlet weak var heroName: UILabel!
    
    /// Imagen del héroe.
    @IBOutlet weak var imageHero: UIImageView!
    
    /// Identificador estático de la celda, utilizado para el registro y la reutilización.
    static var identifier: String {
        return String(describing: HeroesDetailViewCell.self)
    }
    
    /// Método que se llama después de que la vista ha sido cargada desde el archivo nib.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configuración del borde del contentView de la celda.
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        // Aplicar esquinas redondeadas al contentView.
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
    }
}
