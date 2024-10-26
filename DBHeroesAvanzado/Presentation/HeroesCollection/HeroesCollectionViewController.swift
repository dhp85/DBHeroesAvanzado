//
//  HeroesCollectionViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import UIKit

/// Enumeración que define las secciones de la colección de héroes.
enum SectionsHeroes {
    case main
}

/// Controlador de vista para presentar una colección de héroes.
final class HeroesCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! // Colección de héroes.
    
    private var viewModel = HeroesColletionViewModel() // ViewModel para manejar la lógica de la colección.
    private var dataSource: UICollectionViewDiffableDataSource<SectionsHeroes, Hero>? // Fuente de datos para la colección.
    
    // MARK: - Inicializadores
    
    /// Inicializa un nuevo controlador de vista para la colección de héroes.
    /// - Parameter viewModel: ViewModel para manejar la colección de héroes.
    init(viewModel: HeroesColletionViewModel = HeroesColletionViewModel()) {
        self.viewModel = viewModel // Asigna el viewModel proporcionado.
        super.init(nibName: String(describing: HeroesCollectionViewController.self), bundle: nil) // Inicializa la vista con su NIB.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Lanzar error si se utiliza el inicializador por codificación.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() // Llamada a la implementación de la superclase.
        title = "Heroes" // Título de la vista.
        configureCollectionView() // Configura la colección de héroes.
        bind() // Vincula el viewModel con la vista.
        viewModel.loaddata(filter: nil) // Carga los datos de héroes sin filtro.
        configureLogoutButton() // Configura el botón de cierre de sesión.
    }

    // MARK: - Métodos de Configuración

    /// Configura el botón de cierre de sesión en la barra de navegación.
    private func configureLogoutButton() {
        let logoutImage = UIImage(systemName: "escape") // Imagen para el botón de cierre de sesión.
        let logoutButton = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(logoutTapped)) // Botón con acción de cierre de sesión.
        navigationItem.rightBarButtonItem = logoutButton // Agrega el botón a la barra de navegación.
    }
    
    /// Acción que se ejecuta al pulsar el botón de cierre de sesión.
    @objc func logoutTapped() {
         
        SecureDataStore.shared.deleteToken() // Elimina el token de sesión.
        StoreDataProvider.shared.clearBBDD() // Limpia la base de datos local.
        resetToLogin()// Presenta la vista de inicio de sesión.
    }
    /// Restablece la ventana de la aplicación a la pantalla de inicio de sesión.
    ///
    /// Este método establece el controlador de vista raíz de la ventana de la aplicación en un nuevo controlador
    /// de vista de inicio de sesión. Se asegura de que la interfaz de usuario sea presentada dentro de un
    /// UINavigationController para manejar correctamente la navegación en la aplicación.
    ///
    /// - Nota: Se asume que este método se llama en el contexto de una escena activa de la aplicación.
    func resetToLogin() {
        // Intenta obtener la primera escena conectada como UIWindowScene
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        
        // Crea una instancia del controlador de vista de inicio de sesión utilizando un builder
        let loginViewController = SplashBuilder().build()
        
        // Asegura que la presentación sea siempre en UINavigationController
        // Esto permite que la navegación en la aplicación sea manejada correctamente
        window.rootViewController = UINavigationController(rootViewController: loginViewController)
        
        // Hace que la ventana sea clave y visible
        // Esto asegura que la nueva interfaz de usuario sea la que el usuario ve
        window.makeKeyAndVisible()
    }
    
    /// Vincula el estado del viewModel a la vista.
    private func bind() {
        viewModel.statusHeroes.bind { [weak self] status in
            switch status {
            case .dataUpdated:
                // Actualiza la fuente de datos cuando se reciben nuevos datos.
                var snapshot = NSDiffableDataSourceSnapshot<SectionsHeroes, Hero>()
                snapshot.appendSections([.main]) // Agrega la sección principal.
                snapshot.appendItems(self?.viewModel.heroes ?? [], toSection: .main) // Agrega los héroes a la sección.
                self?.dataSource?.apply(snapshot) // Aplica la actualización de datos a la colección.
                
            case .error(reason: let reason):
                // Muestra un mensaje de error si ocurre un fallo.
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true)
                
            case .none:
                break // No realiza ninguna acción si el estado es 'none'.
            }
        }
    }
    
    /// Configura la colección de héroes.
    private func configureCollectionView() {
        collectionView.delegate = self // Establece el delegado de la colección.
        
        let cellRegister = UICollectionView.CellRegistration<HeroesCollectionViewCell, Hero>(cellNib: UINib(nibName: HeroesCollectionViewCell.identifier, bundle: nil)) { cell, indexPath, hero in
            // Configura la celda con datos del héroe.
            cell.nameHeroUILabel.text = hero.name
            cell.heroImageView.setImage(url: hero.photo) // Carga la imagen del héroe.
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: hero) // Dequeue y configura la celda.
        })
    }
}

// MARK: - Extensión para UICollectionViewDelegate y UICollectionViewDelegateFlowLayout
extension HeroesCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// Método que se ejecuta al seleccionar un elemento de la colección.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.heroAt(index: indexPath.row) else {
            return // Retorna si no se encuentra el héroe.
        }
        let navigationDetailHeroe = HeroeDetailBuilder(name: hero).build() // Construye la vista de detalle del héroe.
        self.show(navigationDetailHeroe, sender: self) // Presenta la vista de detalle.
    }
    
    /// Establece el tamaño de cada celda en la colección.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 180) // Tamaño de las celdas.
    }
    
    /// Establece el espaciado mínimo entre las filas de la colección.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Espaciado vertical entre filas.
    }
}
