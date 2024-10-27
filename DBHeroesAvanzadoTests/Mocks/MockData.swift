//
//  MockData.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 27/10/24.
//

import Foundation
@testable import DBHeroesAvanzado


/// Clase Helper para obtneer los data mock que necesitemos para los tests
class MockData {
    
    /// DEvuelve el DATA del json
    static func loadHeroesData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Heroes", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.GokuandrRiends", code: -1)
        }
        return data
    }
    
    
    /// A partir del Data de heroes crea y devuelve el array de ApiHero
    static func mockHeroes() throws -> [APIHero] {
        do {
            let data = try self.loadHeroesData()
            let heroes = try JSONDecoder().decode([APIHero].self, from: data)
            return heroes
        } catch {
            throw error
        }
    }
    
    static func mockTransformations() throws -> [APITransformation] {
        do {
            let data = try self.loadTransformationsData()
            let transformation = try JSONDecoder().decode([APITransformation].self, from: data)
            return transformation
        } catch {
            throw error
        }
    }
    
    static func loadTransformationsData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Transformations", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.GokuandrRiends", code: -1)
        }
        return data
    }
    
    static func mockLocalitation() throws -> [APILocation] {
        do {
            let data = try self.loadLocationsData()
            let localitation = try JSONDecoder().decode([APILocation].self, from: data)
            return localitation
        } catch {
            throw error
        }
    }
    
    static func loadLocationsData() throws -> Data {
        let bundle = Bundle(for: MockData.self)
        guard let url = bundle.url(forResource: "Location", withExtension: "json"),
              let data = try? Data.init(contentsOf: url)  else {
            throw NSError(domain: "io.keepcoding.GokuandrRiends", code: -1)
        }
        return data
    }
    
}


