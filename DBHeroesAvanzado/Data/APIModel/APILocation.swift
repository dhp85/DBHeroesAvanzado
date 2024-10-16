//
//  ApiLocation.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

struct APILocation: Codable {
    let id: String?
    let date: String?
    let latitude: String?
    let longitude: String?
    let hero: APIHero?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "dateShow"
        case latitude = "latitud"
        case longitude = "longitud"
        case hero
        
        
        
    }
}
