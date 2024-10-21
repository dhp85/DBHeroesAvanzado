//
//  GAerror.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//
import Foundation

enum APIErrorResponse: Error, CustomStringConvertible {
    case requestWasNil
    case errorFromServer(error: Error)
    case errorFromApi(statusCode: Int)
    case dataNoReceived
    case errorParsingData
    case sessionTokenMissing
    case badUrl
    
    var description: String {
        switch self {
        case .requestWasNil:
            return "Error creating request"
        case .errorFromServer(error: let error):
            return "Error from server: \((error as NSError).code)"
        case .errorFromApi(statusCode: let statusCode):
            return "Error from API: \(statusCode)"
        case .dataNoReceived:
            return "No data received"
        case .errorParsingData:
            return "Error parsing data"
        case .sessionTokenMissing:
            return "Session token missing"
        case .badUrl:
            return "Bad URL"
        }
    }
}
