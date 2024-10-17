//
//  GAendpoint.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import Foundation

enum APIEndpoint {
    case heroes
    case locations
    case transformations
    
    func path() -> String {
        switch self {
        case .heroes:
            return "/api/heros/all"
        case .locations:
            return "/api/heros/locations"
            case .transformations:
            return "/api/heros/tranformations"
        }
    }
    
    func httpMethord() -> String {
        switch self {
        case .heroes:
            return "POST"
        case .locations:
            return "POST"
        case .transformations:
            return "POST"
        }
    }
}