//
//  GARequestBuilder.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//
import Foundation

final class APIRequestBuilder {
    private let host = "dragonball.keepcoding.education"
    private var request: URLRequest?
    var token: String? {
        secureStorege.getToken()
    }
    private let secureStorege: SecureDataStoreProtocol
    
    init(secureStorege: SecureDataStoreProtocol = SecureDataStore.shared) {
        self.secureStorege = secureStorege
    }
    
    private func url(endPoint: APIEndpoint) throws -> URL {
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
    
    private func setHeaders(params: [String: String]?, requiredAuthorization: Bool = true) throws(APIErrorResponse) {
        if requiredAuthorization {
            guard let token = self.token else {
                throw APIErrorResponse.sessionTokenMissing
            }
            request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
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
            throw APIErrorResponse.requestWasNil
        }
        throw APIErrorResponse.requestWasNil
    }
}
