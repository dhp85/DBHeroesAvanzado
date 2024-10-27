//
//  StoreDataProvider.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import CoreData

/// Enum que define los tipos de persistencia de datos que pueden ser utilizados.
enum TypePersistency {
    case disk      // Persistencia en disco
    case inMemory  // Persistencia en memoria
}

/// Clase que proporciona métodos para gestionar la persistencia de datos utilizando Core Data.
class StoreDataProvider {
    
    /// Instancia compartida de StoreDataProvider, implementando el patrón Singleton.
    static var shared = StoreDataProvider()
    
    static var manageModel: NSManagedObjectModel = {
        let bundle = Bundle(for: StoreDataProvider.self)
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"), let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Error loading model")
        }
        return model
    }()
    
    private let persistency: TypePersistency  // Tipo de persistencia a utilizar
    private let persintentContainer: NSPersistentContainer  // Contenedor persistente de Core Data

    /// Contexto de objeto gestionado (NSManagedObjectContext) para realizar operaciones de Core Data.
    private var context: NSManagedObjectContext {
        let viewContext = persintentContainer.viewContext
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump // Política de fusión de cambios
        return viewContext
    }
    
    /// Inicializador de la clase StoreDataProvider.
    /// - Parameter persistency: Tipo de persistencia a utilizar (por defecto, persistencia en disco).
    init(persistency: TypePersistency = .disk) {
        self.persistency = persistency
        self.persintentContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.manageModel) // Nombre del modelo de datos
        
        // Configurar almacenamiento en memoria si se selecciona
        if self.persistency == .inMemory {
            let persistentStore = persintentContainer.persistentStoreDescriptions.first
            persistentStore?.url = URL(filePath: "/dev/null") // Dirección nula para almacenamiento en memoria
        }
        
        // Cargar las tiendas persistentes
        self.persintentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error loading BBDD: \(error.localizedDescription)") // Error fatal en caso de fallo
            }
        }
    }
    
    /// Guarda los cambios en el contexto actual si hay cambios pendientes.
    func save() {
        if context.hasChanges {
            do {
                try context.save() // Intentar guardar el contexto
            } catch {
                debugPrint("Error saving context: \(error.localizedDescription)") // Reportar error
            }
        }
    }
}

extension StoreDataProvider {
    
    /// Añade héroes al almacenamiento local a partir de datos de la API.
    /// - Parameter heroes: Arreglo de héroes de la API.
    func addhero(heroes: [APIHero]) {
        for hero in heroes {
            let newHero = MOHero(context: context) // Crear nuevo objeto de héroe
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.photo = hero.photo
            newHero.herodescripcion = hero.description
            newHero.favorite = hero.favorite ?? false // Asignar valor de favorito
        }
        save() // Guardar cambios en el contexto
    }
    
    /// Recupera héroes del almacenamiento local con un filtro y ordenación opcionales.
    /// - Parameters:
    ///   - filter: Predicado para filtrar los héroes.
    ///   - sortAscending: Indica si se debe ordenar en orden ascendente (por defecto, true).
    /// - Returns: Arreglo de héroes (MOHero).
    func fetchHeroes(filter: NSPredicate?, sortAscending: Bool = true) -> [MOHero] {
        let request = MOHero.fetchRequest() // Crear solicitud de fetch para héroes
        request.predicate = filter // Asignar filtro
        let sortDescriptor = NSSortDescriptor(keyPath: \MOHero.name, ascending: sortAscending) // Descriptor de ordenación
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request) // Intentar obtener héroes
        } catch {
            debugPrint("Error loading heroes: \(error.localizedDescription)") // Reportar error
            return [] // Retornar arreglo vacío en caso de error
        }
    }
    
    /// Añade localizaciones al almacenamiento local a partir de datos de la API.
    /// - Parameter locations: Arreglo de localizaciones de la API.
    func addLocation(locations: [APILocation]) {
        for location in locations {
            let newLocation = MOLocation(context: context) // Crear nuevo objeto de localización
            newLocation.id = location.id
            newLocation.date = location.date
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            
            // Asignar el héroe correspondiente a la localización
            if let heroId = location.hero?.id {
                let predicate = NSPredicate(format: "id == %@", heroId)
                let hero = fetchHeroes(filter: predicate).first // Buscar héroe
                newLocation.hero = hero // Asignar héroe a la localización
            }
        }
        save()
    }
    
    /// Añade transformaciones al almacenamiento local a partir de datos de la API.
    /// - Parameter transformations: Arreglo de transformaciones de la API.
    func addTransformation(transformations: [APITransformation]) {
        for transformation in transformations {
            let newTransformation = MOTransformation(context: context) // Crear nuevo objeto de transformación
            newTransformation.id = transformation.id
            newTransformation.name = transformation.name
            newTransformation.photo = transformation.photo
            newTransformation.info = transformation.description
            
            // Asignar el héroe correspondiente a la transformación
            if let heroId = transformation.hero?.id {
                let predicate = NSPredicate(format: "id == %@", heroId)
                let hero = fetchHeroes(filter: predicate).first // Buscar héroe
                newTransformation.hero = hero // Asignar héroe a la transformación
            }
        }
        save()
    }
    
    /// Borra todos los datos en la base de datos.
    func clearBBDD() {
        let heroesBatchDelete = NSBatchDeleteRequest(fetchRequest: MOHero.fetchRequest()) // Solicitud de eliminación por lotes para héroes
        let locationsBatchDelete = NSBatchDeleteRequest(fetchRequest: MOLocation.fetchRequest()) // Solicitud de eliminación por lotes para localizaciones
        let transformationsBatchDelete = NSBatchDeleteRequest(fetchRequest: MOTransformation.fetchRequest()) // Solicitud de eliminación por lotes para transformaciones
        
        let deleteTask = [heroesBatchDelete, locationsBatchDelete, transformationsBatchDelete] // Arreglo de tareas de eliminación
        
        for task in deleteTask {
            do {
                try context.execute(task) // Ejecutar la tarea de eliminación
                context.reset() // Reiniciar el contexto
            } catch {
                debugPrint("Error clearing BBDD \(error.localizedDescription)") // Reportar error
            }
        }
    }
}
