//
//  Binding.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 17/10/24.
//

import Foundation

/// Clase que implementa un patrón de enlace (binding) para observar cambios en un estado específico.
/// Esta clase permite que las vistas o componentes se actualicen automáticamente cuando cambia el estado.
final class Binding<State> {
    
    /// Tipo que define el bloque de finalización a ser llamado cuando el valor cambia.
    typealias completion = (State) -> Void
    
    /// Valor privado que almacena el estado actual.
    private var _value: State
    
    /// Bloque de finalización opcional que se invoca cuando el valor cambia.
    var complet: completion?
    
    /// Propiedad que expone el valor actual.
    /// Al establecer un nuevo valor, se notifica al bloque de finalización.
    var value: State {
        get { _value }
        set {
           
            DispatchQueue.main.async {
                self._value = newValue
                self.complet?(self._value)
            }
        }
    }
    
    /// Inicializa una nueva instancia de `Binding` con un valor inicial.
    /// - Parameter value: El valor inicial del estado que se va a vincular.
    init(_ value: State) {
        self._value = value
    }
    
    /// Método que permite vincular un bloque de finalización a cambios en el valor.
    /// - Parameter completion: Bloque que se ejecuta cuando el valor cambia.
    func bind(completion: @escaping completion) {
        complet = completion
    }
}
