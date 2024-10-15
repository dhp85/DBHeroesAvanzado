//
//  StoreDataProvider.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import CoreData

class StoreDataProvider {
    
    private let persintentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persintentContainer.viewContext
    }
    
    init() {
        self.persintentContainer = NSPersistentContainer(name: "Model")
        self.persintentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error loading BBDD: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint("Error saving context: \(error.localizedDescription)")
            }
        }
    }
}

extension StoreDataProvider {
    
    func addhero(heroes: [ApiHero]) {
        
        for hero in heroes {
            let newHero = MOHero(context: context)
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.photo = hero.photo
            newHero.herodescripcion = hero.description
            newHero.favorite = hero.favorite ?? false
        }
        save()
    }
    func fetchHeroes(filter: NSPredicate?) -> [MOHero] {
        let request = MOHero.fetchRequest()
        request.predicate = filter
        
        do {
            return try context.fetch(request)
        } catch {
            debugPrint("Error loading heroes: \(error.localizedDescription)")
            return []
        }
        
        
        // Si estuvieramos interesados solo en el numero de registros.
        // usar el metodo count de context es mucho mas efectivo.
        //try? context.count(for: request)
    }
    
    func addLocation(locations: [ApiLocation]) {
        for location in locations {
            let newLocation = MOLocation(context: context)
            newLocation.id = location.id
            newLocation.date = location.date
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            
            if let heroId = location.hero?.id {
                let predicate = NSPredicate(format: "id == %@", heroId)
                let hero = fetchHeroes(filter: predicate).first
                newLocation.hero = hero
                
            }
        }
    }
    
    func addTransformation(transformations: [MOTransformation]) {
        for transformation in transformations {
            let newTransformation = MOTransformation(context: context)
            newTransformation.id = transformation.id
            newTransformation.name = transformation.name
            newTransformation.photo = transformation.photo
            newTransformation.info = transformation.info
            
            if let heroId = transformation.hero?.id {
                let predicate = NSPredicate(format: "id == %@", heroId)
                let hero = fetchHeroes(filter: predicate).first
                newTransformation.hero = hero
            }
        }
        
    }
}
