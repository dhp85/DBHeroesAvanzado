//
//  ApiProviderTests.swift
//  DBHeroesAvanzadoTests
//
//  Created by Diego Herreros Parron on 27/10/24.
//

import XCTest
@testable import DBHeroesAvanzado

/// Clase para hacer Testing de Api PRovider
final class ApiProviderTests: XCTestCase {
    
    var sut: APISession!
    
    override func setUpWithError() throws {
        
        // Configuramos APi Provider
        //      .Usamos ephemeral porque no usa disco para anda
        //      .Le indicamso que lso protocols será nuestro Mock
        //      .Creamso la session
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        
        // PAra el request Provider usamos nuestro mock para SEcureDataStorage
        let requestProvider = APIRequestBuilder(secureStorege: SecureDataStorageMock())
        
        // creamos ApiProvider
        sut = APISession(session: session, requestBuilder: requestProvider)
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        // Hacemso reset de los objetos
        SecureDataStorageMock().deleteToken()
        URLProtocolMock.handler = nil
        URLProtocolMock.error = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_loadHeros_shouldReturn_26_Heroes() throws {
        // Given
        
        //preparamso la info que nos va a hacer falta para el test
        let expecrtedToken = "Some Token"
        let expectedHero = try MockData.mockHeroes().first!
        var heroesResponse = [APIHero]()
        URLProtocolMock.handler = { request in
            
            // En el Handle, validamos la request, httpmethod, url, headers, lo que consideremos oportuno,
            // se podría comprobar el body pro ejemplo también. Esrta request es la que crea nuestra app
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/all"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expecrtedToken)")
            
            // Devolvemso Data y response del Handler
            let data = try MockData.loadHeroesData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return  (data, response)
        }
        
        // When
        // Una vez tenemso los datos para código asuncrono creamos expectations
        // Indicando que ya ha erminado con expectation.fulfill()""
        // llamamos a nuestro método de la api y validamos que la respuesta es  la resperada
        let expectation = expectation(description: "Load Heroes")
        setToken(expecrtedToken)
        sut.loadHeros { result in
            switch result {
            case .success(let apiheroes):
                heroesResponse = apiheroes
                expectation.fulfill()
            case .failure( _):
                XCTFail("Success expected")
            }
        }
        
        //Then
        
        // Validamso los datos recibidos
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroesResponse.count, 26)
        let heroReceived = heroesResponse.first
        XCTAssertEqual(heroReceived?.id, expectedHero.id)
        XCTAssertEqual(heroReceived?.name, expectedHero.name)
        XCTAssertEqual(heroReceived?.description, expectedHero.description)
        XCTAssertEqual(heroReceived?.favorite, expectedHero.favorite)
        XCTAssertEqual(heroReceived?.photo, expectedHero.photo)
        
    }
    
    func test_loadHerosError_shouldReturn_Error() throws {
        // Given
        
        // para datos de error es más sencillo, le asignamos el error testar a URLprotocolMock
        let expecrtedToken = "Some Token"
        var error: APIErrorResponse?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // When
        // Una vez tenemso los datos para código asuncrono creamos expectations
        // Indicando que ya ha erminado con expectation.fulfill()""
        // llamamos a nuestro método de la api y validamos que la respuesta es  la resperada
        let expectation = expectation(description: "Load Heroes Error")
        setToken(expecrtedToken)
        sut.loadHeros { result in
            switch result {
            case .success( _):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        }
        
        //Then
        // Validamso que tenemos el error y su mensaje.
        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Error from server: \(503)")
    }
    
    func setToken(_ token: String) {
        SecureDataStorageMock().set(token: token)
    }
    
    func test_loadTransformations_shouldReturn_5Transformations() throws {
        // Given
        
        // preparamos la info que nos va a hacer falta para el test
        
        let expecrtedToken = "Some Token"
        let expectedHero = try MockData.mockTransformations().first!
        var heroesResponse = [APITransformation]()
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expecrtedToken)")
            
            // Devolvemso Data y response del Handler
            let data = try MockData.loadTransformationsData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return  (data, response)
        }
        
        let freezer = "D13991A5-6E61-4554-8AA9-D35D0CF3DE58"
        let expectation = expectation(description: "Load Transformations")
        setToken(expecrtedToken)
        sut.loadtransformation(id: freezer, completion: { result in
            switch result {
            case .success(let transformations):
                heroesResponse = transformations
                print(transformations)
                expectation.fulfill()
            case .failure:
                XCTFail("Error loading transformations")
            }
            
        })
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(heroesResponse.count, 5)
        let heroReceived = heroesResponse.first
        XCTAssertEqual(heroReceived?.id, expectedHero.id)
        XCTAssertEqual(heroReceived?.description, expectedHero.description)
        XCTAssertEqual(heroReceived?.name, expectedHero.name)
        XCTAssertEqual(heroReceived?.photo, expectedHero.photo)
        
    }
    
    func test_TransformationsError_shouldReturn_Error() throws {
        // Given
        
        // para datos de error es más sencillo, le asignamos el error testar a URLprotocolMock
        let expecrtedToken = "Some Token"
        var error: APIErrorResponse?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // When
        // Una vez tenemso los datos para código asuncrono creamos expectations
        // Indicando que ya ha erminado con expectation.fulfill()""
        // llamamos a nuestro método de la api y validamos que la respuesta es  la resperada
        let freezer = "D13991A5-6E61-4554-8AA9-D35D0CF3DE58"
        let expectation = expectation(description: "Load Transformations Error")
        setToken(expecrtedToken)
        sut.loadtransformation(id: freezer, completion: { result in
            switch result {
            case .success( _):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        })
        
        //Then
        // Validamso que tenemos el error y su mensaje.
        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Error from server: \(503)")
    }
    
    func test_loadLocations_shouldReturn_location() throws {
        // Given
        
        // preparamos la info que nos va a hacer falta para el test
        
        let expecrtedToken = "Some Token"
        let expectedlocation = try MockData.mockLocalitation().first!
        print(expectedlocation)
        var locationResponse = [APILocation]()
        URLProtocolMock.handler = { request in
            let expectedUrl = try XCTUnwrap(URL(string: "https://dragonball.keepcoding.education/api/heros/locations"))
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.absoluteString, expectedUrl.absoluteString)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(expecrtedToken)")
            
            // Devolvemso Data y response del Handler
            let data = try MockData.loadLocationsData()
            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return  (data, response)
        }
        
        let freezer = "D13991A5-6E61-4554-8AA9-D35D0CF3DE58"
        let expectation = expectation(description: "Load Locations")
        setToken(expecrtedToken)
        sut.loadLocations(id: freezer, completion: { result in
            switch result {
            case .success(let location):
                locationResponse = location
                expectation.fulfill()
            case .failure:
                XCTFail("Error loading locations")
            }
            
        })
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(locationResponse.count, 1)
        let locationReceived = locationResponse.first
        XCTAssert(((locationReceived?.id) != nil))
        XCTAssert(((locationReceived?.latitude) != nil))
        XCTAssert(((locationReceived?.longitude) != nil))
        XCTAssert(((locationReceived?.date) != nil))
        
        
        
    }
    func test_LocationsError_shouldReturn_Error() throws {
        // Given
        
        // para datos de error es más sencillo, le asignamos el error testar a URLprotocolMock
        let expecrtedToken = "Some Token"
        var error: APIErrorResponse?
        URLProtocolMock.error = NSError(domain: "ios.Keepcoding", code: 503)
        
        // When
        // Una vez tenemso los datos para código asuncrono creamos expectations
        // Indicando que ya ha erminado con expectation.fulfill()""
        // llamamos a nuestro método de la api y validamos que la respuesta es  la resperada
        let freezer = "D13991A5-6E61-4554-8AA9-D35D0CF3DE58"
        let expectation = expectation(description: "Load Locations Error")
        setToken(expecrtedToken)
        sut.loadLocations(id: freezer, completion: { result in
            switch result {
            case .success( _):
                XCTFail("Error expected")
            case .failure(let receivedError):
                error = receivedError
                expectation.fulfill()
            }
        })
        
        //Then
        // Validamso que tenemos el error y su mensaje.
        wait(for: [expectation], timeout: 2)
        let receivedError = try XCTUnwrap(error)
        XCTAssertEqual(receivedError.description, "Error from server: \(503)")
    }
}
