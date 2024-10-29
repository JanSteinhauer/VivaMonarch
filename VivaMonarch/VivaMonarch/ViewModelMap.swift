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
    @State private var canadaEntity: Entity?
    static var canadaEntityText: Entity?
    @State var candaTriggert = false
    
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
                            ViewModelMap.canadaEntityText = canada
                            print("Canada entity assigned to canadaEntity state.")
                        }
                    } else {
                        print("Canada entity not found within AmericaMap.")
                    }
                } else {
                    print("Failed to load AmericaMap entity.")
                }
            }
            .modifier(ConditionalGestureModifier(canadaEntity: canadaEntity))
        }
    }
}


struct ConditionalGestureModifier: ViewModifier {
    let canadaEntity: Entity?
    
    func body(content: Content) -> some View {
        if let canadaEntity = canadaEntity {
            
            content.gesture(
                SpatialTapGesture()
                    .targetedToEntity(canadaEntity)
                    .onEnded { value in
                        // Since value.entity is non-optional, no need for 'if let'
                        let tappedEntity = value.entity
                        print("Entity tapped: \(tappedEntity.name)")

                        // Safely unwrap 'canadaEntity'
                        if tappedEntity == canadaEntity {
                            // Create a text entity with the description of Canada
                            let description = "Canada is a country in North America known for its vast landscapes and multicultural communities."
                            let textMesh = MeshResource.generateText(
                                description,
                                extrusionDepth: 0.01,
                                font: .systemFont(ofSize: 0.05),
                                containerFrame: .zero,
                                alignment: .center,
                                lineBreakMode: .byWordWrapping
                            )
                            let material = SimpleMaterial(color: .white, isMetallic: false)
                            let textEntity = ModelEntity(mesh: textMesh, materials: [material])
                            
                            // Position the text entity next to the "canada" entity
                            textEntity.position = tappedEntity.position + SIMD3<Float>(0.1, 0, 0)
                            
                            // Add the text entity to the parent entity
                            tappedEntity.parent?.addChild(textEntity)
                        }
                    }
            )
        } else {
            content
        }
    }
}

