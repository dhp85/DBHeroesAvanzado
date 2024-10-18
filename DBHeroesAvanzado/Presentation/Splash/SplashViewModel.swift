//
//  SplashViewModel.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 18/10/24.
//

import Foundation

// Enum que representa los estados posibles del splash
enum SplashState {
    case loading
    case error(reason: String)
    case none
    case ready // Agregamos el estado "ready" para indicar cuando el video ha acabado.
}

final class SplashViewModel {
    
    // Propiedad que permitirá enlazar los cambios de estado
    var onStateChange: Binding<SplashState> = Binding(.none)
    
    // Método para iniciar la carga del splash (o iniciar la observación)
    func load() {
        // Cambiamos el estado a "loading"
        onStateChange.value = .loading
        
        // Agregamos el observador de la notificación "endVideo"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleVideoEnd),
                                               name: .endVideo,
                                               object: nil)
    }
    
    // Método que se llama cuando se recibe la notificación de que el video terminó
    @objc private func handleVideoEnd(_ notification: Notification) {
        // Cambiamos el estado a ready para indicar que el video o "carga" ha terminado
        onStateChange.value = .ready
        
        //Eliminar el observador aquí
        NotificationCenter.default.removeObserver(self, name: .endVideo, object: nil)
    }
}
