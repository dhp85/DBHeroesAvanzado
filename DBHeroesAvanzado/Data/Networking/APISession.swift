//
//  ApiProvider.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import Foundation

protocol APISessionProtocol {
    func loadHeros(name: String, completion: @escaping ((Result<[APIHero], APIErrorResponse>) -> Void))
    func loadLocations(id: String, completion: @escaping ((Result<[APILocation], APIErrorResponse>) -> Void))
    func loadtransformation(id: String, completion: @escaping ((Result<[APITransformation], APIErrorResponse>) -> Void))
    func login(user: String, password: String,completion: @escaping ((Result<String, APIErrorResponse>) -> Void))
}

final class APISession: APISessionProtocol {
    
    /// Instancia de URLSession que se utiliza para realizar las solicitudes.
    private let session: URLSession
    
    /// Instancia de APIRequestBuilder que se utiliza para construir las solicitudes API.
    private let requestBuilder: APIRequestBuilder
    
    /// Inicializador de la clase.
    /// - Parameters:
    ///   - session: Instancia de URLSession que se utilizará. Por defecto es la sesión compartida.
    ///   - requestBuilder: Instancia de APIRequestBuilder que se utilizará para construir las solicitudes. Por defecto es una nueva instancia de APIRequestBuilder.
    init(session: URLSession = .shared, requestBuilder: APIRequestBuilder = APIRequestBuilder()) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    /// Carga una lista de héroes de la API.
    /// - Parameters:
    ///   - name: Nombre del héroe a buscar. Por defecto es una cadena vacía, lo que indica que se cargarán todos los héroes.
    ///   - completion: Cierre que se llamará con el resultado de la solicitud. El resultado puede ser una lista de héroes o un error de la API.
    func loadHeros(name: String = "", completion: @escaping ((Result<[APIHero], APIErrorResponse>) -> Void)) {
        do {
            // Construimos la solicitud utilizando el requestBuilder
            let request = try requestBuilder.buildRequest(endPoint: .heroes, params: ["name": name])
            makeRequest(request: request, completion: completion)
        } catch {
            // En caso de error en la construcción de la solicitud, llamamos al closure de finalización con el error.
            completion(.failure(error))
        }
    }
    
    /// Carga una lista de ubicaciones de la API.
    /// - Parameters:
    ///   - id: El identificador de la ubicación a buscar.
    ///   - completion: Cierre que se llamará con el resultado de la solicitud. El resultado puede ser una lista de ubicaciones o un error de la API.
    func loadLocations(id: String, completion: @escaping ((Result<[APILocation], APIErrorResponse>) -> Void)) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .locations, params: ["id": id])
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Carga las transformaciones de un héroe de la API.
    /// - Parameters:
    ///   - id: El identificador del héroe cuyas transformaciones se desean cargar.
    ///   - completion: Cierre que se llamará con el resultado de la solicitud. El resultado puede ser una lista de transformaciones o un error de la API.
    func loadtransformation(id: String, completion: @escaping ((Result<[APITransformation], APIErrorResponse>) -> Void)) {
        do {
            let request = try requestBuilder.buildRequest(endPoint: .transformations, params: ["id": id])
            makeRequest(request: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Realiza la solicitud HTTP y maneja la respuesta.
    /// - Parameters:
    ///   - request: La solicitud que se va a enviar.
    ///   - completion: Cierre que se llamará con el resultado de la solicitud. El resultado puede ser una respuesta exitosa o un error.
    private func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T, APIErrorResponse>) -> Void)) {
        session.dataTask(with: request) { data, response, error in
            // Manejo de errores de la solicitud
            if let error {
                completion(.failure(.errorFromServer(error: error)))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            
            // Verificación del código de estado de la respuesta
            if httpResponse?.statusCode != 200 {
                completion(.failure(.errorFromApi(statusCode: statusCode ?? -1)))
                return
            }
            
            // Manejo de los datos recibidos
            if let data {
                do {

                    // Intentamos decodificar los datos recibidos en el tipo esperado T
                    let apiInfo = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(apiInfo))
                } catch {
                    // Si ocurre un error en la decodificación, se llama al closure de finalización con un error de datos no recibidos
                    completion(.failure(.dataNoReceived))
                }
            } else {
                // Si no se recibieron datos, se llama al closure de finalización con un error de datos no recibidos
                completion(.failure(.dataNoReceived))
            }
        }.resume() // Inicia la tarea de la solicitud
    }
    
    func login(user: String, password: String, completion: @escaping ((Result<String, APIErrorResponse>) -> Void)) {
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.dataNoReceived)) // Manejo de error en la conversión de datos
            return
        }
        let base64String = loginData.base64EncodedString()
        
        do {
            // Construimos la solicitud para iniciar sesión
            let url = try requestBuilder.url(endPoint: .login)
            var request = URLRequest(url: url)
            request.httpMethod = APIEndpoint.login.httpMethord()
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request) { data, response, error in
                
                guard let data else {
                    completion(.failure(.dataNoReceived))
                    return
                }
                
                guard error == nil else {
                    completion(.failure(.errorFromServer(error: error!)))
                    return
                }
                
                let httpResponse = response as? HTTPURLResponse
                let statusCode = httpResponse?.statusCode
                
                if httpResponse?.statusCode != 200 {
                    completion(.failure(.errorFromApi(statusCode: statusCode ?? -1)))
                    return
                }
                
                guard let token = String(data: data, encoding: .utf8) else {
                    completion(.failure(.dataNoReceived))
                    return
                }
                
                SecureDataStore.shared.set(token: token) 
                completion(.success(token))
                
            }
            task.resume()
            
            
        } catch {
            completion(.failure(.requestWasNil)) // Manejo del error en la construcción de la solicitud
        }
    }
}
