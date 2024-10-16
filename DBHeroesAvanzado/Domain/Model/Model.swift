//
//  Model.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

struct Hero {
    let id: String
    let name: String
    let photo: String
    let favorite: Bool
    let description: String
    
    init(id: String, name: String, photo: String, favorite: Bool, description: String) {
        self.id = id
        self.name = name
        self.photo = photo
        self.favorite = favorite
        self.description = description
    }
    
    init(moHero: MOHero) {
        self.id = moHero.id ?? ""
        self.name = moHero.name ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
        self.description = moHero.herodescripcion ?? ""
    }
}



