//
//  HeroAnnotation.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit


final class HeroAnnotation: NSObject, MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
