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
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6InByaXZhdGUifQ.eyJpZGVudGlmeSI6IkZCRjlCRTNGLTZDODAtNDYxQi05QUUwLUMwNTE5QjQ4RjFGNyIsImVtYWlsIjoiZGllZ29ocDg1QGdtYWlsLmNvbSIsImV4cGlyYXRpb24iOjY0MDkyMjExMjAwfQ.5WUS4Xh7D7CqYW1QhfY9JQ5DyjECKGNqkyVDwbFX8LE"
    
    private func url(endPoint: APIEndpoint) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = endPoint.path()
        return components.url
    }
    
    private func setHeaders(params: [String: String]?) {
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let params {
            request?.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    func buildRequest(endPoint: APIEndpoint, params: [String: String]) -> URLRequest? {
        guard let url = self.url(endPoint: endPoint) else { return nil }
        request = URLRequest(url: url)
        request?.httpMethod = endPoint.httpMethord()
        setHeaders(params: params)
        
        return request
    }
}
