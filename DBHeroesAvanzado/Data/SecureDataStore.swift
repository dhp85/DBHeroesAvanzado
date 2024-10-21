//
//  SecureDataStore.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 21/10/24.
//


import KeychainSwift

/// Protocolo que define las operaciones para el almacenamiento seguro de datos.
protocol SecureDataStoreProtocol {
    /// Almacena un token en el almacenamiento seguro.
    /// - Parameter token: El token que se va a almacenar.
    func set(token: String)
    
    /// Recupera el token almacenado en el almacenamiento seguro.
    /// - Returns: El token almacenado o `nil` si no existe.
    func getToken() -> String?
    
    /// Elimina el token del almacenamiento seguro.
    func deleteToken()
}

/// Clase que implementa el almacenamiento seguro de datos utilizando Keychain.
/// Esta clase es responsable de gestionar el almacenamiento, recuperación y eliminación de tokens de sesión.
class SecureDataStore: SecureDataStoreProtocol {
    
    /// Clave utilizada para almacenar el token en Keychain.
    private let kToken = "kToken"
    
    /// Instancia de `KeychainSwift` que proporciona acceso al Keychain.
    private let keychain = KeychainSwift()
    
    /// Instancia compartida de `SecureDataStore` para su uso en toda la aplicación.
    static let shared: SecureDataStore = .init()
    
    /// Almacena un token en el Keychain.
    /// - Parameter token: El token que se va a almacenar.
    func set(token: String) {
        keychain.set(token, forKey: kToken)
    }
    
    /// Recupera el token almacenado en el Keychain.
    /// - Returns: El token almacenado o `nil` si no existe.
    func getToken() -> String? {
        keychain.get(kToken)
    }
    
    /// Elimina el token del Keychain.
    func deleteToken() {
        keychain.delete(kToken)
    }
}

