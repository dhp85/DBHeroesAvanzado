//
//  SecureDataStorageMock.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 27/10/24.
//

import Foundation
@testable import DBHeroesAvanzado

///Mock para SecureDataStorage, implementa el protocol
/// Igual que SecureDataStorage pero en vez de usar KEyChain usamos Userdefaults
class SecureDataStorageMock: SecureDataStoreProtocol {
    
    private let kToken = "kToken"
    private var userDefaults = UserDefaults.standard
    
    func set(token: String) {
        userDefaults.set(token, forKey: kToken)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: kToken)
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: kToken)
    }
}
