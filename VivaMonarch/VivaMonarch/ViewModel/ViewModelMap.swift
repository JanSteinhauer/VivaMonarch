import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation

struct ViewModelMap: View {
    @State private var canadaEntity: Entity?
    @State private var usEntity: Entity?
    @State private var mexicoEntity: Entity?
    
    @State private var currentlyPlayingEntity: Entity?
    @StateObject private var audioManager = AudioManager()


    var body: some View {
        ZStack {
            RealityView { content in
                print("Loading AmericaMap entity...")
                if let americaMapEntity = try? await Entity(named: "AmericaMap", in: realityKitContentBundle) {
                    print("AmericaMap entity successfully loaded.")
                    content.add(americaMapEntity)
                    
                    // Enable collision detection for the entire entity hierarchy
                    americaMapEntity.generateCollisionShapes(recursive: true)
                    print("Collision shapes generated for AmericaMap entity.")
                    
                    // Find the "canada" entity within the "AmericaMap"
                    if let canada = americaMapEntity.findEntity(named: "canada") {
                        print("Canada entity found within AmericaMap.")
                        DispatchQueue.main.async {
                            self.canadaEntity = canada
                            print("Canada entity assigned to canadaEntity state.")
                        }
                    } else {
                        print("Canada entity not found within AmericaMap.")
                    }
                    
                    // Find the "us" entity within the "AmericaMap"
                    if let us = americaMapEntity.findEntity(named: "us") {
                        print("US entity found within AmericaMap.")
                        DispatchQueue.main.async {
                            self.usEntity = us
                            print("US entity assigned to usEntity state.")
                        }
                    } else {
                        print("US entity not found within AmericaMap.")
                    }
                    
                    // Find the "mexico" entity within the "AmericaMap"
                    if let mexico = americaMapEntity.findEntity(named: "mexico") {
                        print("Mexico entity found within AmericaMap.")
                        DispatchQueue.main.async {
                            self.mexicoEntity = mexico
                            print("Mexico entity assigned to mexicoEntity state.")
                        }
                    } else {
                        print("Mexico entity not found within AmericaMap.")
                    }
                } else {
                    print("Failed to load AmericaMap entity.")
                }
            }
            .modifier(ConditionalGestureModifier(
                            canadaEntity: canadaEntity,
                            usEntity: usEntity,
                            mexicoEntity: mexicoEntity,
                            currentlyPlayingEntity: $currentlyPlayingEntity,
                            audioManager: audioManager
                        ))
            .onAppear {
                           audioManager.playSound(named: "AmericaGeneral.wav")
                       }
        }
    }
}

// Custom component to store reference to the text entity
struct TextComponent: Component {
    var textEntity: Entity
}

struct ConditionalGestureModifier: ViewModifier {
    let canadaEntity: Entity?
    let usEntity: Entity?
    let mexicoEntity: Entity?
    
    @Binding var currentlyPlayingEntity: Entity?
    
    @State private var audioPlayer: AVAudioPlayer?
    @ObservedObject var audioManager: AudioManager
    
    func body(content: Content) -> some View {
        content.gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    let tappedEntity = value.entity
                    print("Entity tapped: \(tappedEntity.name)")
                    
                    var description: String?
                    var soundFileName: String?
                    var countryEntity: Entity?
                    
                    if let canadaEntity = canadaEntity, tappedEntity == canadaEntity {
                        description = "Canada’s landscapes mark the start of the monarch butterfly migration south."
                        soundFileName = "Canada.wav"
                        countryEntity = canadaEntity
                    } else if let usEntity = usEntity, tappedEntity == usEntity {
                        description = "The U.S. provides a key route and breeding ground for migrating monarchs."
                        soundFileName = "USA.wav"
                        countryEntity = usEntity
                    } else if let mexicoEntity = mexicoEntity, tappedEntity == mexicoEntity {
                        description = "Mexico’s forests host monarchs each winter, completing their migration."
                        soundFileName = "Mexico.wav"
                        countryEntity = mexicoEntity
                    } else {
                        // Not an entity we're interested in
                        return
                    }
                    
                    guard let description = description,
                          let soundFileName = soundFileName,
                          let countryEntity = countryEntity else { return }
                    
                    
                    audioManager.stopAudio()
                    
                    // Play the audio for the tapped country entity
                    audioManager.playSound(named: soundFileName)
                    currentlyPlayingEntity = countryEntity
                    
                    
                    // Check if the text entity is already displayed
                    if let textComponent = countryEntity.components[TextComponent.self] as? TextComponent {
                        // Remove the text entity
                        textComponent.textEntity.removeFromParent()
                        // Remove the component
                        countryEntity.components.remove(TextComponent.self)
                    } else {
                        // Create and display the text entity
                        
                        // Define the size of the text container to wrap the text
                        let containerWidth: CGFloat = 0.3 // Adjust the width as needed
                        let containerHeight: CGFloat = 0.1 // Adjust the height as needed
                        
                        // Create a text mesh with wrapping
                        let textMesh = MeshResource.generateText(
                            description,
                            extrusionDepth: 0.001,
                            font: .systemFont(ofSize: 0.02),
                            containerFrame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight),
                            alignment: .center,
                            lineBreakMode: .byWordWrapping
                        )
                        
                        // Create material for the text (black font)
                        let textMaterial = SimpleMaterial(color: .black, isMetallic: false)
                        
                        // Create the text entity
                        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
                        
                        // Adjust the pivot of the textEntity to center it
                        let textBounds = textEntity.visualBounds(relativeTo: nil)
                        textEntity.position = -textBounds.center + SIMD3<Float>(0, 0, 0.001)
                        
                        // Create a background plane (white background)
                        let backgroundMesh = MeshResource.generatePlane(width: Float(containerWidth), height: Float(containerHeight), cornerRadius: 0.02)
                        let backgroundMaterial = SimpleMaterial(color: .white, isMetallic: false)
                        let backgroundEntity = ModelEntity(mesh: backgroundMesh, materials: [backgroundMaterial])
                        
                        // Background entity is centered by default
                        
                        // Disable collision and interaction on text and background entities
                        textEntity.components.remove(CollisionComponent.self)
                        backgroundEntity.components[CollisionComponent.self] = nil
                        
                        // Create a parent entity to hold both the text and background
                        let parentEntity = Entity()
                        parentEntity.addChild(backgroundEntity)
                        parentEntity.addChild(textEntity)
                        
                        // Disable collision on parent entity
                        parentEntity.components[CollisionComponent.self] = nil
                        
                        // Position the parent entity above the country entity (y + 0.2 meters)
                        parentEntity.position = countryEntity.position + SIMD3<Float>(0, 0.2, 0)
                        
                        // Add the parent entity to the scene
                        countryEntity.parent?.addChild(parentEntity)
                        
                        // Store a reference to the text entity in the country entity's components
                        countryEntity.components[TextComponent.self] = TextComponent(textEntity: parentEntity)
                    }
                }
        )
    }
    
    private func playSound(named soundFileName: String) {
            guard let path = Bundle.main.path(forResource: soundFileName, ofType: nil) else { return }
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Could not load file \(soundFileName)")
            }
        }

        // Function to stop audio playback
        private func stopAudio() {
            audioPlayer?.stop()
            audioPlayer = nil
        }
}




