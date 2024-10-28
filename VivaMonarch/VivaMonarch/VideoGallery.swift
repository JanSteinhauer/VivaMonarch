import SwiftUI
import RealityKit
import AVFoundation
import simd

@Observable
class VideoGallery {

    // Adjusted plane size to match 9:16 aspect ratio
    private let planeWidth: Float = 1.0   // Width of the video plane
    private let planeHeight: Float = 1.7778  // Height (1.0 * 16/9)

    private var contentEntity = Entity()
    private var videoPlayer: AVPlayer?
    private var videoEntity: ModelEntity?

    func setupContentEntity() -> Entity {

        // Setup the content
        setup()

        // Add skydome
        addSkydome()

        return contentEntity
    }

    // MARK: - Private

    private func setup() {

        // Video URL
        guard let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/greenshiftai.appspot.com/o/WhatsApp%20Video%202024-08-31%20at%2021.53.24.mp4?alt=media&token=81c03508-c3e8-4479-b941-cc9d44651e02") else {
            print("Invalid video URL")
            return
        }

        // Create AVPlayer
        videoPlayer = AVPlayer(url: videoURL)
        videoPlayer?.play() // Pause when video ends

        // Create the video plane entity
        let entity = makePlane(name: "videoPlane", videoPlayer: videoPlayer!)

        // Position the video directly in front of the user
        entity.position = SIMD3<Float>(1, 1.6, -1.0) // Adjust Z value for distance

        let rotationAngle = -40.0 * (.pi / 180.0) // Convert to radians
              entity.orientation = simd_quatf(angle: Float(rotationAngle), axis: SIMD3<Float>(0, 1, 0))


        // Add the entity to the content entity
        contentEntity.addChild(entity)

        // Store reference to video entity for interaction
        videoEntity = entity
    }

    private func makePlane(name: String, videoPlayer: AVPlayer) -> ModelEntity {

        // Create a VideoMaterial
        let material = VideoMaterial(avPlayer: videoPlayer)

        // Create the plane with the specified aspect ratio
        let entity = ModelEntity(
            mesh: .generatePlane(width: planeWidth, height: planeHeight),
            materials: [material]   
        )

        entity.name = name

        // Enable user interaction
        entity.generateCollisionShapes(recursive: false)
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

        // Add gesture recognizer
       
        return entity
    }

    private func handleTap() {
        guard let player = videoPlayer else { return }

        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
    }

    private func addSkydome() {
        // Create a large sphere to act as the skydome
        let sphere = ModelEntity(mesh: .generateSphere(radius: 50))

        // Create an orange material
        var material = UnlitMaterial()
        material.color = .init(tint: .orange)

        sphere.model?.materials = [material]

        // Flip the sphere inside out by scaling it negatively on all axes
        sphere.scale = SIMD3<Float>(-1, -1, -1)

        sphere.position = SIMD3<Float>(0, 0, 0)

        // Add the skydome to the content entity
        contentEntity.addChild(sphere)
    }
}
