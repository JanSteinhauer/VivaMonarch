import RealityKit
import Observation
import AVFoundation
import WebKit

@Observable
class ViewModel {

    private var contentEntity = Entity()
    private let avPlayer = AVPlayer()

    func setupContentEntity() -> Entity {
        setupAvPlayer()
        let material = VideoMaterial(avPlayer: avPlayer)

        let sphere = try! Entity.load(named: "Sphere")
        sphere.scale = .init(x: 1E3, y: 1E3, z: 1E3)

        let modelEntity = sphere.children[0].children[0] as! ModelEntity
        modelEntity.model?.materials = [material]

        contentEntity.addChild(sphere)
        contentEntity.scale *= .init(x: -1, y: 1, z: 1)

        return contentEntity
    }

    func play() {
        avPlayer.play()
    }

    func pause() {
        avPlayer.pause()
    }

    private func setupAvPlayer() {
//        let url = Bundle.main.url(forResource: "ayutthaya", withExtension: "mp4")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/flutterthroughvr.appspot.com/o/VID_20240310_112115_00_011.mp4?alt=media&token=26a9354d-35b3-4894-8a17-dfcfc10151aa")
        let asset = AVAsset(url: url!)
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
    }
}
