//
//  Transformation.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import Foundation

struct Transformation: Hashable {
    let id: String
    let name: String
    let info: String
    let photo: String
    
    init(moTransformation: MOTransformation) {
        self.id = moTransformation.id ?? ""
        self.name = moTransformation.name ?? ""
        self.info = moTransformation.info ?? ""
        self.photo = moTransformation.photo ?? ""
    }
}
