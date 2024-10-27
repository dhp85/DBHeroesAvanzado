//
//  DBHeroesAvanzadoTests.swift
//  DBHeroesAvanzadoTests
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import XCTest
@testable import DBHeroesAvanzado

final class StoreProviderTests: XCTestCase {
    
    var sut : StoreDataProvider!

    override func setUpWithError() throws {

        try super.setUpWithError()
        sut = StoreDataProvider(persistency: .inMemory)
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_addHeroes_shouldReturnTheItemsInserted() throws {
        //Given
        let initialCount = sut.fetchHeroes(filter: nil).count
        let apiHero = APIHero(id: "123", name: "Goku", photo: "photo", favorite: false, description: "fuerte")
        
        //When
        sut.addhero(heroes: [apiHero])
        let heroes = sut.fetchHeroes(filter: nil)
        let finalCount = heroes.count
        
        //Then
        XCTAssertEqual(finalCount, initialCount + 1)
        let hero = try XCTUnwrap(heroes.first)
        XCTAssertEqual(hero.id, apiHero.id)
        XCTAssertEqual(hero.herodescripcion, apiHero.description)
        XCTAssertEqual(hero.photo, apiHero.photo)
        XCTAssertEqual(hero.favorite, apiHero.favorite)
    }
    
    func test_fetchHeroes_shouldBeSortedAsc() throws {
        // Given
        let initialCount = sut.fetchHeroes(filter: nil).count
        let apiHero = APIHero(id: "123", name: "Goku", photo: "photo", favorite: false, description: "fuerte")
        let apiHero2 = APIHero(id: "123", name: "Vegeta", photo: "photo", favorite: false, description: "fuerte")
        
        // When
        sut.addhero(heroes: [apiHero, apiHero2])
        let heroes = sut.fetchHeroes(filter: nil)
    
        //Then
        XCTAssertEqual(initialCount, 0)
        let hero = try XCTUnwrap(heroes.first)
        XCTAssertEqual(hero.id, apiHero2.id)
        XCTAssertEqual(hero.herodescripcion, apiHero2.description)
        XCTAssertEqual(hero.photo, apiHero2.photo)
        XCTAssertEqual(hero.favorite, apiHero2.favorite)
        
        
    }
    
    func test_addLocations_ShouldInsertLocationAndAssociateHero() throws {
        // Given
        let apiHero = APIHero(id: "123", name: "Goku", photo: "photo", favorite: false, description: "fuerte")
        let apiLocation = APILocation(id: "Id", date: "date", latitude: "0000", longitude: "11111", hero: apiHero)
        
        // When
        sut.addhero(heroes: [apiHero])
        sut.addLocation(locations: [apiLocation])
        let heroes = sut.fetchHeroes(filter: nil)
        let hero = try XCTUnwrap(heroes.first)
        
        // Then
        XCTAssertEqual(hero.locations?.count, 1)
        let location = try XCTUnwrap(hero.locations?.first)
        
        XCTAssertEqual(location.id, apiLocation.id)
        XCTAssertEqual(location.date, apiLocation.date)
        XCTAssertEqual(location.latitude, apiLocation.latitude)
        XCTAssertEqual(location.longitude, apiLocation.longitude)
        XCTAssertEqual(location.hero?.id, hero.id)
    }

}
