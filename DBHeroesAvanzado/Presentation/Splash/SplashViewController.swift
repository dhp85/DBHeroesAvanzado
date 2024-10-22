//
//  SplashViewController.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//

import UIKit
import AVFoundation


class SplashViewController: UIViewController {

    private let viewModel: SplashViewModel
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
        // Configurar la ruta del video
        if let path = Bundle.main.path(forResource: "dbanime", ofType:"mp4") {
            let url = URL(fileURLWithPath: path)
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill // Asegura que el video llene la pantalla
            if let playerLayer = playerLayer {
                view.layer.addSublayer(playerLayer)
            }
        }

        // Silenciar el video
        player?.volume = 0.0 // Establece el volumen a 0 para silenciar
    }
    
    private func bind() {
        viewModel.onStateChange.bind { [weak self] state in
            switch state {
            
            case .loading:
                return
            case .error(let reason):
                let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert,animated: true)
            case .none:
                break
            case .ready:
                self?.present(LoginBuilder().build(), animated: true)
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Ajustar el marco del AVPlayerLayer para ocupar toda la vista
        playerLayer?.frame = view.bounds // Ocupar toda la vista
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play() // Reproducir el video
        
        // Cambiar a la vista principal después de que termine el video
        // Usamos KVO para observar cuándo termina el video
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
    }

    // Método para observar el final del video
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem, playerItem.status == .readyToPlay {
                player?.play() // Asegúrate de que se reproduzca solo cuando esté listo
            }
            
            // Escucha cuando el video termina de reproducirse
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidReachEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player?.currentItem)
        }
    }

    @objc func playerDidReachEnd(notification: Notification) {
        // No reiniciar el video, solo hacer la transición
        transitionEndVideo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause() // Pausar el video si la vista desaparece
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanupPlayer() // Limpiar el reproductor al desaparecer la vista
    }

    private func cleanupPlayer() {
        // Limpiar el reproductor y liberar memoria
        player?.replaceCurrentItem(with: nil) // Libera el item actual
        player = nil // Libera el reproductor
        playerLayer?.removeFromSuperlayer() // Elimina la capa del reproductor
        playerLayer = nil // Libera la capa
        NotificationCenter.default.removeObserver(self) // Eliminar observador
    }

    private func transitionEndVideo() {
        // Pausar el reproductor antes de hacer la transición
        player?.pause()
        self.cleanupPlayer() // Limpiar el reproductor después de la presentación
        NotificationCenter.default.post(name: .endVideo, object: self)
        }
    }

extension Notification.Name {
    static let endVideo = Notification.Name("endVideo")
}
