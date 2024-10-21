

import Foundation

enum LoginState {
    case success
    case error(reason: String)
    case loading
    case none
}


final class LoginViewModel {
    
    let onStateChange = Binding<LoginState>(.none)
    
}
