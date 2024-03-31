import RealityKit
import AVFoundation
import Combine
import Observation

@Observable
class ViewModel {

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
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/vivamonarch-b34f3.appspot.com/o/Monarch6.mp4?alt=media&token=b8b6bb34-ce96-426e-9c03-ee2947883e94")
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
}
