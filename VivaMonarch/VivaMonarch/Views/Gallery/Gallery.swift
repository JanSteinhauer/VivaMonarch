import SwiftUI
import RealityKit
import simd

@Observable
class Gallery {

    private let planeSize = CGSize(width: 0.32 * 2, height: 0.18 * 2) // Scaled by a factor of 2
    private let maxPlaneSize = CGSize(width: 3.0, height: 2.0)

    private var contentEntity = Entity()
    private var images: [MaterialParameters.Texture] = []
    private var sorted = true

    func setupContentEntity() -> Entity {
        if images.isEmpty {
            loadImages()
            setup()
            addSkydome()
        }
        return contentEntity
    }


    func toggleSorted() {
        if sorted {
            sorted.toggle()
            randomSetChildPositions()
        } else {
            sorted.toggle()
            resetChildPositions()
        }
    }

    // MARK: - Private
    
    private func loadImages(){
        for i in 1..<13 {
            let name = "laputa\(String(format: "%03d", i))"
            if let texture = try? TextureResource.load(named: name) {
                images.append(.init(texture))
            }
        }
    }

    private func setup() {

        let totalImages = images.count
        let radius: Float = 3.0  // Adjust the radius as needed

        for i in 0..<totalImages {
            let image = images[i]

            // Calculate the angle for even distribution around the circle
            let angle = 2 * Float.pi * Float(i) / Float(totalImages)

            // Calculate the position on the circle
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            let y: Float = 1.6  // Set Y coordinate to 1.6 meters

            let position = SIMD3<Float>(x, y, z)

            // Create the image plane entity
            let entity = makePlane(name: "", position: position, texture: image)

            // Rotate the entity to face the origin
            let direction = normalize(SIMD3<Float>(-x, 0, -z)) // Only consider x and z for rotation
            let rotation = simd_quatf(from: [0, 0, 1], to: direction)
            entity.orientation = rotation

            // Add the entity to the content entity
            contentEntity.addChild(entity)
        }
    }

    private func makePlane(name: String, position: SIMD3<Float>, texture: MaterialParameters.Texture) -> ModelEntity {

        var material = UnlitMaterial()
        material.color = .init(texture: texture)

        let entity = ModelEntity(
            mesh: .generatePlane(width: Float(planeSize.width), height: Float(planeSize.height), cornerRadius: 0.0),
            materials: [material],
            collisionShape: .generateBox(width: Float(planeSize.width), height: Float(planeSize.height), depth: 0.1),
            mass: 0.0
        )

        entity.name = name
        entity.position = position
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

        return entity
    }

    private func addSkydome() {
        // Create a large sphere to act as the skydome
        let sphere = ModelEntity(mesh: .generateSphere(radius: 50))

        // Create an orange material
        var material = UnlitMaterial()
        material.color = .init(tint: .init(red: 170/255.0, green: 121/255.0, blue: 66/255.0, alpha: 1.0))

        sphere.model?.materials = [material]

        // Flip the sphere inside out by scaling it negatively on all axes
        sphere.scale = SIMD3<Float>(-1, -1, -1)

        sphere.position = SIMD3<Float>(0, 0, 0)

        // Add the skydome to the content entity
        contentEntity.addChild(sphere)
    }

    private func move(entity: Entity, position: SIMD3<Float>) {
        let move = FromToByAnimation<Transform>(
            name: "move",
            from: .init(scale: .init(repeating: 1), translation: entity.position),
            to: .init(scale: .init(repeating: 1), translation: position),
            duration: 2.0,
            timing: .linear,
            bindTarget: .transform
        )
        let animation = try! AnimationResource.generate(with: move)
        entity.playAnimation(animation, transitionDuration: 2.0)
    }

    private func randomSetChildPositions() {
        let totalImages = contentEntity.children.count
        let radius: Float = 3.0  // Same radius as before

        var usedAngles = Set<Float>()

        for entity in contentEntity.children {
            var angle: Float
            repeat {
                angle = Float.random(in: 0..<2*Float.pi)
            } while usedAngles.contains(angle)
            usedAngles.insert(angle)

            let x = radius * cos(angle)
            let z = radius * sin(angle)
            let y: Float = 1.6

            let position = SIMD3<Float>(x, y, z)
            move(entity: entity, position: position)

            // Rotate the entity to face the origin
            let direction = normalize(SIMD3<Float>(-x, 0, -z))
            let rotation = simd_quatf(from: [0, 0, 1], to: direction)
            entity.orientation = rotation
        }
    }

    private func resetChildPositions() {
        let totalImages = contentEntity.children.count
        let radius: Float = 3.0  // Same radius as before

        for (i, entity) in contentEntity.children.enumerated() {
            let angle = 2 * Float.pi * Float(i) / Float(totalImages)
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            let y: Float = 1.6

            let position = SIMD3<Float>(x, y, z)
            move(entity: entity, position: position)

            // Rotate the entity to face the origin
            let direction = normalize(SIMD3<Float>(-x, 0, -z))
            let rotation = simd_quatf(from: [0, 0, 1], to: direction)
            entity.orientation = rotation
        }
    }
}
