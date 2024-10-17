//
//  Model.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import Foundation

struct Hero: Hashable {
    let id: String
    let name: String
    let photo: String
    let favorite: Bool
    let herodescripcion: String
    
 
    init(moHero: MOHero) {
        self.name = moHero.name ?? ""
        self.id = moHero.id ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
        self.herodescripcion = moHero.herodescripcion ?? ""
    }
}



