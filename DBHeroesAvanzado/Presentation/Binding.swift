//
//  Binding.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 17/10/24.
//

final class Binding<State> {
    
    typealias completion = (State) -> Void
    
    private var _value: State
    var complet: completion?
    
    var value: State {
        get { _value }
        set {
            _value = newValue
            complet?(_value)
        }
    }
    
    init(_ value: State) {
        self._value = value
    }
    
    func bind(completion: @escaping completion) {
        complet = completion
    }
}
