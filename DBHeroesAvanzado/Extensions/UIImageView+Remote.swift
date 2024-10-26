//
//  UIImageView+Remote.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 22/10/24.
//

import UIKit

/// Extensión de UIImageView que proporciona funcionalidad para cargar imágenes desde una URL.
extension UIImageView {
    
    /// Establece la imagen de la UIImageView utilizando una URL de cadena.
    /// - Parameter url: La cadena que representa la URL de la imagen.
    func setImage(url: String) {
        // Intenta crear una URL a partir de la cadena proporcionada.
        guard let urlString = URL(string: url) else { return }
        
        // Llama al método de descarga utilizando URLSession.
        downloadWithURLSession(url: urlString) { [weak self] image in
            // Actualiza la imagen en el hilo principal.
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    /// Descarga una imagen desde una URL utilizando URLSession.
    /// - Parameters:
    ///   - url: La URL desde la cual se descargará la imagen.
    ///   - completion: Closure que se llama con la imagen descargada o nil en caso de error.
    private func downloadWithURLSession(url: URL, completion: @escaping (UIImage?) -> Void) {
        // Crea una tarea de datos con la URL proporcionada.
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            // Verifica si los datos son válidos y crea una imagen a partir de ellos.
            guard let data, let photo = UIImage(data: data) else {
                completion(nil) // Retorna nil si hay un error.
                return
            }
            completion(photo) // Retorna la imagen descargada.
        }
        .resume() // Inicia la tarea de descarga.
    }
}
