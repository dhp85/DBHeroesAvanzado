//
//  Location.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit

struct Location {
    let id: String
    let date: String
    let latitude: String
    let longitude: String
    
    init(moLocation: MOLocation) {
        self.id = moLocation.id ?? ""
        self.date = moLocation.date ?? ""
        self.latitude = moLocation.latitude ?? ""
        self.longitude = moLocation.longitude ?? ""
    }
}

extension Location {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = Double(self.latitude),
              let longitude = Double(self.longitude),
              // la latitud norte o sur no puede tener mas de 120 grados, si es mas, es erronea.
              abs(latitude) <= 90,
              abs(longitude) <= 180 else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
}
