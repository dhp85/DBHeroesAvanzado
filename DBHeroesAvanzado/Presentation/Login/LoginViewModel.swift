

import Foundation

enum LoginState {
    case success
    case error(reason: String)
    case loading
    case none
}


final class LoginViewModel {
    
    private let apiSession = APISession()
    private var storeData = StoreDataProvider()
    
    let onStateChange = Binding<LoginState>(.none)
    
    
    func signIn(user: String?, password: String?) {
        onStateChange.value = .loading
        guard let user, let password , isValid(user, password) else {
            print("Usuario o contraseña no son validos.")
            return
        }
        
        apiSession.login(user: user, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.onStateChange.value = .success
            case .failure(let error):
                self?.onStateChange.value = .error(reason: error.localizedDescription)
            }
        }
    }
    private func isValid(_ email: String, _ password: String) -> Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count >= 4
    }
}
