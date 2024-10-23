//
//  HeroAnnotationView.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit

final class HeroAnnotationView: MKAnnotationView {
    
    static var identifier: String {
        return String(describing: HeroAnnotation.self)
    }
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 40 , height: 40)
        self.centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        self.canShowCallout = true
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        let view = UIImageView(image: UIImage(resource: .bolaDragon))
        addSubview(view)
        view.frame = self.frame
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
}
