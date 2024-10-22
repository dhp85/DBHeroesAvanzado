//
//  GARequestBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//
import Foundation

/// Clase responsable de construir solicitudes API.
/// Proporciona métodos para configurar el URL, los encabezados y los parámetros de las solicitudes.
final class APIRequestBuilder {
    
    /// La dirección del host para las solicitudes.
    private let host = "dragonball.keepcoding.education"
    
    /// Objeto URLRequest que se va a construir.
    private var request: URLRequest?
    
    /// Token de sesión, recuperado del almacenamiento seguro.
    //var token: String? {
      //  secureStorege.getToken()
    //}
    
    /// Almacenamiento seguro donde se guarda el token.
    private let secureStorege: SecureDataStoreProtocol
    
    /// Inicializador de la clase.
    /// - Parameter secureStorege: Instancia que conforma el protocolo `SecureDataStoreProtocol`. Por defecto, se usa `SecureDataStore.shared`.
    init(secureStorege: SecureDataStoreProtocol = SecureDataStore.shared) {
        self.secureStorege = secureStorege
    }
    
    /// Construye una URL para el endpoint proporcionado.
    /// - Parameter endPoint: El endpoint de la API que se va a utilizar.
    /// - Throws: `APIErrorResponse.badUrl` si la URL no es válida.
    /// - Returns: URL construida para el endpoint especificado.
    func url(endPoint: APIEndpoint) throws(APIErrorResponse) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endPoint.path()
        
        if let url = components.url {
            return url
        } else {
            throw APIErrorResponse.badUrl
        }
    }
    
    /// Configura los encabezados de la solicitud.
    /// - Parameters:
    ///   - params: Parámetros opcionales que se incluirán en el cuerpo de la solicitud.
    ///   - requiredAuthorization: Indica si se requiere un encabezado de autorización. Por defecto es `true`.
    /// - Throws: `APIErrorResponse.sessionTokenMissing` si se requiere autorización pero no hay un token.
    private func setHeaders(params: [String: String]?) throws(APIErrorResponse) {
            guard let token = secureStorege.getToken() else {
                throw APIErrorResponse.sessionTokenMissing
            }
            request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    /// Construye una solicitud URLRequest para el endpoint y los parámetros proporcionados.
    /// - Parameters:
    ///   - endPoint: El endpoint de la API que se va a utilizar.
    ///   - params: Diccionario de parámetros que se incluirán en el cuerpo de la solicitud.
    /// - Throws: `APIErrorResponse` si hay un error en la construcción de la solicitud.
    /// - Returns: Una solicitud URLRequest configurada para el endpoint especificado.
    func buildRequest(endPoint: APIEndpoint, params: [String: String]) throws(APIErrorResponse) -> URLRequest {
        do {
            let url = try self.url(endPoint: endPoint)
            request = URLRequest(url: url)
            request?.httpMethod = endPoint.httpMethord()
            try setHeaders(params: params)
            
            if let finalrequest = self.request {
                return finalrequest
            }
        } catch {
            throw error
        }
        throw APIErrorResponse.requestWasNil
    }
}
