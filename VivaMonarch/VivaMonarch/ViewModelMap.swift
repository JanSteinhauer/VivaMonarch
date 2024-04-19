//
//  ViewModelMap.swift
//  VivaMonarch
//
//  Created by Jan Steinhauer on 4/19/24.
//
import SwiftUI
import RealityKit
import RealityKitContent

struct ViewModelMap: View {
    //    @State private var isMovingForward = true
    
    var body: some View {
        ZStack {
            RealityView { content in
                
                if let entity = try? await Entity(named: "AmericaMap", in: realityKitContentBundle){
                    content.add(entity)
                    guard let butterfly = entity.findEntity(named: "Butterfly_Monarch") else { return }
                    if let butterfly = entity.findEntity(named: "Butterfly_Monarch") {
                        print("Butterfly found")
                    } else {
                        print("Butterfly not found")
                    }
                    
                    guard let animationResource = butterfly.availableAnimations.first else { return }
                    let controller = butterfly.playAnimation(animationResource.repeat())
                    controller.speed = Float.random(in: 1..<2.5)
                    
                    if let animationResource = butterfly.availableAnimations.first {
                        let controller = butterfly.playAnimation(animationResource.repeat())
                        controller.speed = Float.random(in: 1..<2.5)
                    }
                    
                    // Apply continuous downward movement to the butterfly
                    applyContinuousMovementAndRotation(to: butterfly)
                }
            }
        }
    }
    
    //    // Function to move the butterfly downwards
    //      private func moveButterflyDownwards(_ entity: Entity) {
    //          // Use a timer to periodically update the position
    //
    //
    //          Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
    //              // Downward movement offset
    //              let zOffset = self.isMovingForward ? 0.02 : -0.02
    //              let yOffset = self.isMovingForward ? 0.01 : -0.01
    //              // Update the entity's position
    //              var transform = entity.transform
    //              transform.translation.z += Float(zOffset)
    //              transform.translation.y += Float(yOffset)
    //              entity.transform = transform
    //
    //              // Optionally, stop the timer if the butterfly reaches a certain limit (not shown)
    //          }
    //      }
    //  }
    
    private func applyContinuousMovementAndRotation(to entity: Entity) {
        var isMovingForward = true
        let timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { _ in
            isMovingForward.toggle()
            applyRotation(to: entity)
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            moveButterfly(entity, isMovingForward: isMovingForward)
        }
    }
    
    // Function to apply rotation to the entity
    private func applyRotation(to entity: Entity) {
        let rotationAngle = simd_quatf(angle: .pi, axis: [-1, 0, 0])  // 180 degrees rotation around the Y-axis
        entity.move(to: Transform(scale: entity.transform.scale, rotation: rotationAngle * entity.transform.rotation, translation: entity.transform.translation), relativeTo: entity.parent, duration: 0.5, timingFunction: .easeInOut)
    }
    
    // Function to move the butterfly
    private func moveButterfly(_ entity: Entity, isMovingForward: Bool) {
        let zOffset: Float = isMovingForward ? 0.02 : -0.02
        let yOffset: Float = isMovingForward ? 0.01 : -0.01
        
        var transform = entity.transform
        transform.translation.z += zOffset
        transform.translation.y += yOffset
        entity.transform = transform
    }
    private func applyRandomMovement(to entity: Entity) {
        // Define the movement range (adjust as needed)
        let range: ClosedRange<Float> = -1.0...1.0
        
        // Create a timer to update the position at regular intervals
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            // Randomize position offsets
            let xOffset = Float.random(in: range) * 0.1
            let yOffset = Float.random(in: range) * 0.1
            let zOffset = Float.random(in: range) * 0.1
            
            // Apply the position offsets
            var transform = entity.transform
            transform.translation += SIMD3(xOffset, yOffset, zOffset)
            entity.move(to: transform, relativeTo: entity.parent, duration: 1.0, timingFunction: .linear)
        }
    }
}

//#Preview{
//    ViewModelMap()
//}
