import RealityKit
import AVFoundation
import Combine
import Observation

@Observable
class ViewModel {
    private var contentEntity = Entity()
    private var avPlayer = AVPlayer()
    private var playerItem: AVPlayerItem?
    private var endPlaybackObserver: Any?

    var urlString: String? {
        didSet {
            setupAvPlayer()
        }
    }


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
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
        setupLooping()
    }

    private func setupLooping() {
        if let observer = endPlaybackObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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
        // Remove previous content entity if any
        contentEntity.children.removeAll()

        let avPlayerMaterial = VideoMaterial(avPlayer: avPlayer)

        let sphere = try! Entity.load(named: "Sphere")
        sphere.scale = .init(x: 1E3, y: 1E3, z: 1E3)

        let modelEntity = sphere.children[0].children[0] as! ModelEntity
        modelEntity.model?.materials = [avPlayerMaterial]

        contentEntity.addChild(sphere)
        contentEntity.scale = .one // Reset scale before applying inversion
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
