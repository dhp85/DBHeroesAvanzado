//
//  ApiTransformation.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

struct ApiTransformation: Codable {
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    let hero: ApiHero
}
