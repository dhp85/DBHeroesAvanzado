

import Foundation

/// Enum que representa el estado del proceso de inicio de sesión.
enum LoginState {
    case success
    case error(reason: String)
    case loading
    case none
}

/// Clase que gestiona la lógica del inicio de sesión.
final class LoginViewModel {
    
    // MARK: - Propiedades Privadas
    
    private let apiSession = APISession() // Instancia de APISession para manejar las solicitudes de red.
    private var storeData = StoreDataProvider.shared // Instancia compartida del proveedor de datos de almacenamiento.
    
    /// Binding que notifica a la vista sobre cambios en el estado del inicio de sesión.
    let onStateChange = Binding<LoginState>(.none)
    
    // MARK: - Métodos Públicos
    
    /// Método para iniciar sesión con el nombre de usuario y la contraseña proporcionados.
    /// - Parameters:
    ///   - user: El nombre de usuario o correo electrónico del usuario que intenta iniciar sesión.
    ///   - password: La contraseña del usuario.
    func signIn(user: String, password: String) {
        // Validación del nombre de usuario.
        guard validateUsername(user) else {
            onStateChange.value = .error(reason: "Correo electrónico no válido.")
            return
        }
        
        // Validación de la contraseña.
        guard validatePassword(password) else {
            onStateChange.value = .error(reason: "Contraseña no válida.")
            return
        }
        
        // Cambiar el estado a 'cargando' mientras se realiza la solicitud de inicio de sesión.
        onStateChange.value = .loading
        
        // Realizar la solicitud de inicio de sesión a través de apiSession.
        apiSession.login(user: user, password: password) { [weak self] result in
            switch result {
            case .success(_):
                // Cambiar el estado a 'éxito' si el inicio de sesión fue exitoso.
                self?.onStateChange.value = .success
            case .failure(let error):
                // Cambiar el estado a 'error' con el mensaje de error proporcionado.
                self?.onStateChange.value = .error(reason: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Métodos Privados
    
    /// Verifica si el correo electrónico y la contraseña son válidos.
    /// - Parameters:
    ///   - email: El correo electrónico del usuario.
    ///   - password: La contraseña del usuario.
    /// - Returns: `true` si ambos son válidos, `false` en caso contrario.
    private func isValid(_ email: String, _ password: String) -> Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count >= 4
    }
    
    /// Valida que el nombre de usuario cumpla con los criterios requeridos.
    /// - Parameter username: El nombre de usuario o correo electrónico del usuario.
    /// - Returns: `true` si el nombre de usuario es válido, `false` en caso contrario.
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    /// Valida que la contraseña cumpla con los criterios requeridos.
    /// - Parameter password: La contraseña del usuario.
    /// - Returns: `true` si la contraseña es válida, `false` en caso contrario.
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}
