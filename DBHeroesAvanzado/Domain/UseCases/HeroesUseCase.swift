//
//  HeroesUseCaseProtocol.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 16/10/24.
//

import Foundation

protocol HeroesUseCaseProtocol {
    func loadHeros(filter: String?, completion: @escaping (Result<[Hero], APIErrorResponse>) -> Void)
}

final class HeroesUseCase: HeroesUseCaseProtocol {
    
    func loadHeros(filter: String? = nil, completion: @escaping (Result<[Hero], APIErrorResponse>) -> Void) {
        
    }
}
