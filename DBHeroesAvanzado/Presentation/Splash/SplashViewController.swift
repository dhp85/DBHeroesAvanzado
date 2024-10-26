//
//  SplashViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import UIKit
import AVFoundation

/// Controlador de vista que gestiona la pantalla de presentación (Splash Screen) de la aplicación.
class SplashViewController: UIViewController {

    // MARK: - Propiedades Privadas
    
    private let viewModel: SplashViewModel // Instancia del ViewModel que maneja la lógica de la pantalla de presentación.
    var player: AVPlayer? // Reproductor de video para mostrar la animación de presentación.
    var playerLayer: AVPlayerLayer? // Capa para mostrar el video en la vista.

    // MARK: - Inicializadores

    /// Inicializa el controlador de vista con un ViewModel específico.
    /// - Parameter viewModel: El ViewModel que contiene la lógica para la pantalla de presentación.
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashViewController", bundle: Bundle(for: type(of: self)))
    }

    /// Inicializador requerido para decodificación desde Interface Builder.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Ciclo de Vida de la Vista

    override func viewDidLoad() {
        super.viewDidLoad()
        bind() // Establece el enlace entre la vista y el ViewModel.
        viewModel.load() // Carga datos relevantes desde el ViewModel.

        // Configurar la ruta del video de la presentación
        if let path = Bundle.main.path(forResource: "dbanime", ofType: "mp4") {
            let url = URL(fileURLWithPath: path) // Crea una URL del archivo de video.
            player = AVPlayer(url: url) // Inicializa el reproductor de video con la URL.
            
            playerLayer = AVPlayerLayer(player: player) // Crea una capa para mostrar el video.
            playerLayer?.videoGravity = .resizeAspectFill // Asegura que el video llene la pantalla.
            if let playerLayer = playerLayer {
                view.layer.addSublayer(playerLayer) // Agrega la capa de video a la vista.
            }
        }

        // Silenciar el video
        //player?.volume = 0.0 // Establece el volumen a 0 para silenciar el audio.
    }

    // MARK: - Métodos de Binding

    /// Establece el enlace entre el ViewModel y la vista para manejar los cambios de estado.
    private func bind() {
        viewModel.onStateChange.bind { [weak self] state in
            switch state {
            case .loading:
                return // No se requiere acción específica durante el estado de carga.
            case .error(let reason):
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert) // Muestra un alert en caso de error.
                alert.addAction(UIAlertAction(title: "Ok", style: .default)) // Acción de botón para cerrar el alert.
                self?.present(alert, animated: true) // Presenta el alert.
            case .none:
                break // No se requiere acción para el estado 'none'.
            case .ready:
                self?.present(LoginBuilder().build(), animated: true) // Presenta la vista de inicio de sesión cuando esté lista.
            }
        }
    }

    // MARK: - Métodos de Ciclo de Vida de la Vista

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Ajusta el marco del AVPlayerLayer para ocupar toda la vista
        playerLayer?.frame = view.bounds // Asegura que el video ocupe toda la vista.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play() // Inicia la reproducción del video.
        
        // Cambia a la vista principal después de que termine el video
        // Se usa KVO para observar cuándo termina el video.
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
    }

    // MARK: - Observación del Reproductor

    /// Método para observar el final del video.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem, playerItem.status == .readyToPlay {
                player?.play() // Asegúrate de que se reproduzca solo cuando esté listo.
            }
            
            // Escucha cuando el video termina de reproducirse.
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidReachEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player?.currentItem) // Observa la notificación de fin de reproducción.
        }
    }

    // MARK: - Métodos de Manejo de Eventos

    @objc func playerDidReachEnd(notification: Notification) {
        // No reiniciar el video, solo hacer la transición
        transitionEndVideo() // Maneja la transición al final del video.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause() // Pausa el video si la vista desaparece.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanupPlayer() // Limpiar el reproductor al desaparecer la vista.
    }

    // MARK: - Métodos de Limpieza

    private func cleanupPlayer() {
        // Limpia el reproductor y libera memoria.
        player?.replaceCurrentItem(with: nil) // Libera el ítem actual del reproductor.
        player = nil // Libera el reproductor.
        playerLayer?.removeFromSuperlayer() // Elimina la capa del reproductor de la vista.
        playerLayer = nil // Libera la capa.
        NotificationCenter.default.removeObserver(self) // Elimina el observador de notificaciones.
    }

    // MARK: - Métodos de Transición

    private func transitionEndVideo() {
        // Pausa el reproductor antes de hacer la transición.
        player?.pause()
        self.cleanupPlayer() // Limpia el reproductor después de la presentación.
        NotificationCenter.default.post(name: .endVideo, object: self) // Publica una notificación indicando que el video ha terminado.
    }
}

// MARK: - Extensiones

/// Extensión para agregar notificaciones personalizadas relacionadas con el final del video.
extension Notification.Name {
    static let endVideo = Notification.Name("endVideo") // Notificación que indica el fin del video.
}
