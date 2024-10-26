//
//  HeroDetailStatus.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//


import Foundation

/// Enum que representa los posibles estados del detalle del héroe.
enum HeroDetailStatus {
    case locationUpdated // Indica que la ubicación ha sido actualizada.
    case error(reason: String) // Indica que ha ocurrido un error con una razón específica.
    case none // Indica que no hay un estado activo.
}

/// Clase ViewModel que gestiona los datos y la lógica para los detalles de un héroe.
final class HeroDetailViewModel {
    
    // MARK: - Propiedades Privadas
    
    private(set) var hero: Hero // Héroe cuyas transformaciones y ubicación se están gestionando.
    private var heroLocations: [Location] = [] // Array que almacena las ubicaciones del héroe.
    private var useCase: HeroDetailUseCaseProtocol // Protocolo que define los casos de uso para cargar datos del héroe.
    private(set) var transformation: [Transformation] = [] // Array que almacena las transformaciones del héroe.
    
    var status: Binding<HeroDetailStatus> = Binding(.none) // Binding para el estado del detalle del héroe.
    var annotations: [HeroAnnotation] = [] // Anotaciones de ubicación del héroe para el mapa.
    
    // MARK: - Inicializador
    
    /// Inicializa el ViewModel con un héroe y un caso de uso opcional.
    /// - Parameters:
    ///   - hero: El héroe cuyas transformaciones y ubicaciones se van a gestionar.
    ///   - useCase: Implementación del caso de uso para cargar datos del héroe.
    init(hero: Hero, useCase: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
        self.hero = hero
        self.useCase = useCase
    }
    
    // MARK: - Métodos Públicos
    
    /// Carga los datos del héroe, incluidas sus transformaciones y ubicaciones.
    func loadData() {
        loadTransformations() // Carga las transformaciones del héroe.
        loadLocations() // Carga las ubicaciones del héroe.
    }
    
    // MARK: - Métodos Privados
    
    /// Carga las transformaciones del héroe desde el caso de uso.
    private func loadTransformations() {
        useCase.loadTransformationsForHeroWith(id: hero.id) { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.transformation = transformations // Asigna las transformaciones cargadas.
                self?.status.value = .locationUpdated // Actualiza el estado a 'locationUpdated'.
            case .failure(let error):
                self?.status.value = .error(reason: error.description) // Maneja el error y actualiza el estado.
            }
        }
    }
    
    /// Carga las ubicaciones del héroe desde el caso de uso.
    private func loadLocations() {
        useCase.loadLocationsForHeroWith(id: hero.id) { [weak self] result in
            switch result {
            case .success(let locations):
                self?.heroLocations = locations // Asigna las ubicaciones cargadas.
                self?.createAnnotations() // Crea las anotaciones para el mapa.
            case .failure(let error):
                self?.status.value = .error(reason: error.description) // Maneja el error y actualiza el estado.
            }
        }
    }
    
    /// Crea anotaciones de ubicación para el héroe a partir de las ubicaciones cargadas.
    private func createAnnotations() {
        self.annotations = [] // Reinicia las anotaciones.
        heroLocations.forEach { [weak self] location in
            guard let coordinate = location.coordinate else {
                return // Sale si la ubicación no tiene coordenadas.
            }
            let annotation = HeroAnnotation(title: self?.hero.name, coordinate: coordinate) // Crea una anotación para la ubicación.
            self?.annotations.append(annotation) // Añade la anotación a la lista de anotaciones.
        }
        self.status.value = .locationUpdated // Actualiza el estado a 'locationUpdated'.
    }
    
    /// Retorna la transformación en una posición específica del array de transformaciones.
    /// - Parameter index: Índice de la transformación deseada.
    /// - Returns: La transformación en el índice dado o nil si el índice es inválido.
    func transformationAt(index: Int) -> Transformation? {
        guard index < transformation.count else {
            return nil // Retorna nil si el índice es mayor que la cantidad de transformaciones.
        }
        return transformation[index] // Retorna la transformación en el índice especificado.
    }
}
