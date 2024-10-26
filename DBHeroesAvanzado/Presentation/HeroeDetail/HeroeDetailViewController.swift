//
//  HeroeDetailViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 23/10/24.
//

import MapKit

/// Enum para las secciones de la colección de transformaciones.
enum SectionsTransformation {
    case main
}

/// Controlador de vista que presenta los detalles de un héroe, incluyendo su descripción y transformaciones.
final class HeroeDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionTransformations: UICollectionView! // Colección que muestra las transformaciones del héroe.
    @IBOutlet weak var descriptionHeroUILabel: UILabel! // Etiqueta que muestra la descripción del héroe.
    @IBOutlet weak var imageMap: MKMapView! // Mapa que muestra la ubicación relacionada con el héroe.
    
    // MARK: - Propiedades Privadas
    
    private let viewModel: HeroDetailViewModel // Instancia del ViewModel que gestiona los datos del héroe.
    private var locationManager: CLLocationManager = CLLocationManager() // Gestor de ubicación para gestionar la ubicación del usuario.
    private var dataSource: UICollectionViewDiffableDataSource<SectionsTransformation, Transformation>? // Fuente de datos difusa para la colección.
    
    // MARK: - Inicializadores
    
    /// Inicializa el controlador de vista con un ViewModel específico.
    /// - Parameter viewModel: El ViewModel que contiene la lógica para los detalles del héroe.
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroeDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    /// Inicializador requerido para decodificación desde Interface Builder.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de Vida de la Vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.hero.name // Establece el título de la vista como el nombre del héroe.
        configureCollectionView() // Configura la colección de transformaciones.
        bind() // Establece el enlace entre la vista y el ViewModel.
        viewModel.loadData() // Carga los datos del héroe.
        imageMap.delegate = self // Establece el delegado del mapa.
        checkLocationAuthorizationStatus() // Verifica el estado de autorización de la ubicación.
    }
    
    // MARK: - Métodos de Binding
    
    /// Establece el enlace entre el ViewModel y la vista para manejar los cambios de estado.
    func bind() {
        viewModel.status.bind { [weak self] status in
            switch status {
            case .locationUpdated:
                self?.setupMap() // Configura el mapa con la ubicación actualizada.
                self?.configureView() // Configura la vista con la información del héroe.
                
                var snapshot = NSDiffableDataSourceSnapshot<SectionsTransformation, Transformation>()
                snapshot.appendSections([.main]) // Agrega la sección principal.
                snapshot.appendItems(self?.viewModel.transformation ?? [], toSection: .main) // Agrega las transformaciones al snapshot.
                self?.dataSource?.apply(snapshot) // Aplica el snapshot a la fuente de datos.
            case .error(reason: let reason):
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert) // Muestra un alert en caso de error.
                alert.addAction(UIAlertAction(title: "Ok", style: .default)) // Acción de botón para cerrar el alert.
                self?.present(alert, animated: true) // Presenta el alert.
            case .none:
                break // No se requiere acción para el estado 'none'.
            }
        }
    }
    
    // MARK: - Configuración de la Vista
    
    private func configureView() {
        descriptionHeroUILabel.text = viewModel.hero.herodescripcion // Establece la descripción del héroe en la etiqueta.
    }
    
    // MARK: - Configuración del Mapa
    
    private func configureMap() {
        imageMap.delegate = self // Establece el delegado del mapa.
        imageMap.showsUserLocation = true // Muestra la ubicación del usuario en el mapa.
        imageMap.showsUserTrackingButton = true // Muestra el botón de seguimiento del usuario.
    }
    
    /// Configura el mapa añadiendo anotaciones y centrando la vista en la ubicación del héroe.
    private func setupMap() {
        let oldAnnotations = self.imageMap.annotations // Obtiene las anotaciones existentes.
        self.imageMap.removeAnnotations(oldAnnotations) // Elimina las anotaciones viejas.
        self.imageMap.addAnnotations(viewModel.annotations) // Agrega las anotaciones del ViewModel al mapa.
        
        if let annotation = viewModel.annotations.first {
            imageMap.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000) // Centra el mapa en la primera anotación.
        }
    }
    
    // MARK: - Verificación de Autorización de Ubicación
    
    private func checkLocationAuthorizationStatus() {
        let authorizationStatus = locationManager.authorizationStatus // Obtiene el estado de autorización de ubicación.
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Solicita autorización si no ha sido determinada.
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Inicia la actualización de la ubicación si está autorizado.
        case .denied, .restricted:
            imageMap.showsUserLocation = false // Oculta la ubicación del usuario si está denegada o restringida.
            imageMap.showsUserTrackingButton = false // Oculta el botón de seguimiento del usuario si está denegada o restringida.
        @unknown default:
            break // Maneja cualquier caso desconocido.
        }
    }
    
    // MARK: - Configuración de la Colección
    
    private func configureCollectionView() {
        collectionTransformations.delegate = self // Establece el delegado de la colección.
        
        let cellRegister = UICollectionView.CellRegistration<HeroesDetailViewCell, Transformation>(cellNib: UINib(nibName: HeroesDetailViewCell.identifier, bundle: nil)) {
            cell, indexPath, transformation in
            cell.heroName.text = transformation.name // Establece el nombre del héroe en la celda.
            cell.imageHero.setImage(url: transformation.photo) // Establece la imagen del héroe en la celda.
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionTransformations, cellProvider: { collectionView, indexPath, transformation in
            collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: transformation) // Dequeue y configura la celda.
        })
    }
}

// MARK: - Extensiones para Delegados

extension HeroeDetailViewController: MKMapViewDelegate {
    
    /// Proporciona una vista de anotación personalizada para el mapa.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HeroAnnotation else {
            return nil // Retorna nil si la anotación no es del tipo esperado.
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.identifier) {
            return annotationView // Retorna una vista de anotación existente si está disponible.
        }
        
        let annotationView = HeroAnnotationView(annotation: annotation, reuseIdentifier: HeroAnnotationView.identifier) // Crea una nueva vista de anotación.
        return annotationView
    }
    
    /// Maneja la acción de tocar un control accesorio en la vista de anotación.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("calloutAccessoryControlTapped") // Imprime un mensaje de depuración cuando se toca el control.
    }
}

extension HeroeDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// Maneja la selección de un ítem en la colección.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.transformationAt(index: indexPath.row) else {
            return // Sale si no hay un héroe en la transformación seleccionada.
        }
        let navigationTransformationHeroe = HeroTransformationBuilder(transformation: hero).build() // Crea el controlador de vista para la transformación del héroe.
        self.present(navigationTransformationHeroe, animated: true) // Presenta el controlador de vista.
    }
    
    /// Establece el tamaño de los ítems en la colección.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) // Retorna un tamaño fijo para cada ítem.
    }
}
