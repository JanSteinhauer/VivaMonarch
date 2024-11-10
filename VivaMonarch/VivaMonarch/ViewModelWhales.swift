//
//  ViewModelWhales.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 11/9/24.
//

import RealityKit
import AVFoundation
import Combine
import Observation

@Observable
class ViewModelWhales {

    private var contentEntity = Entity()
    private let avPlayer = AVPlayer()
    private var playerItem: AVPlayerItem?
    private var endPlaybackObserver: Any?

    init() {
        setupAvPlayer()
        setupLooping()
    }

    deinit {
        if let observer = endPlaybackObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setupAvPlayer() {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/greenshiftai.appspot.com/o/Whale%20North%20Sunset%20Final%20A.mp4?alt=media&token=68d4186f-2ccb-4740-b423-de77e0a805be")
        let asset = AVAsset(url: url!)
        playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
    }

    private func setupLooping() {
        endPlaybackObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: nil
        ) { [weak self] _ in
            self?.avPlayer.seek(to: CMTime.zero)
            self?.avPlayer.play()
        }
    }

    func setupContentEntity() -> Entity {
        let avPlayerMaterial = VideoMaterial(avPlayer: avPlayer)

        let sphere = try! Entity.load(named: "Sphere")
        sphere.scale = .init(x: 1E3, y: 1E3, z: 1E3)

        let modelEntity = sphere.children[0].children[0] as! ModelEntity
        modelEntity.model?.materials = [avPlayerMaterial]

        // Create a red overlay material
        let redOverlayMaterial = SimpleMaterial(color: .black.withAlphaComponent(0.5), isMetallic: false)

        // Create an overlay entity with the red material
        let overlayEntity = ModelEntity(mesh: .generateSphere(radius: 0.5), materials: [redOverlayMaterial])
        
        // Match the scale of the model entity and make it 5 times bigger
        overlayEntity.scale = modelEntity.scale * 10.0 // Multiply each component of the scale by 5

        overlayEntity.position = modelEntity.position + [0, 0, 0.1] // Slightly in front of the model entity

        // Add both the model and overlay entities to the contentEntity
        contentEntity.addChild(sphere)
//        contentEntity.addChild(overlayEntity) // Add the overlay entity
        contentEntity.scale *= .init(x: -1, y: 1, z: 1)

        return contentEntity
    }



    
    

    func play() {
        avPlayer.play()
    }

    func pause() {
        avPlayer.pause()
    }
}

