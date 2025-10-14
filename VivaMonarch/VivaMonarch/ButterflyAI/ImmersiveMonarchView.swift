//
//  ImmersiveMonarchView.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 14.10.25.
//

import SwiftUI
import RealityKit
import RealityKitContent // <- keep this if your .usdz lives here

enum ImmersiveIDs { static let monarchSpace = "MonarchSpace" }

@MainActor
struct ImmersiveMonarchView: View {
    var body: some View {
        RealityView { content in
            // Skydome (inward-facing)
            let sky = ModelEntity(mesh: .generateSphere(radius: 6.0))
            sky.model?.materials = [UnlitMaterial(color: .init(red: 1, green: 0.55, blue: 0.10, alpha: 1))]
            sky.scale.x = -1
            content.add(sky)

            // Anchor ~1.3 m high, 1.2 m in front
            let anchor = AnchorEntity()
            anchor.position = [0, 1.3, -1.2]
            content.add(anchor)

            // Load butterfly.usdz
            Task {
                if let butterfly = await loadButterflyEntity() {
                    butterfly.transform.scale = .init(repeating: 0.4)
                    let baseY: Float = butterfly.position.y
                    butterfly.components.set(HoverComponent(baseY: baseY))
                    anchor.addChild(butterfly)
                } else {
                    // Final fallback: tiny box (should rarely happen)
                    let fallback = ModelEntity(
                        mesh: .generateBox(size: 0.08),
                        materials: [SimpleMaterial(color: .orange, isMetallic: false)]
                    )
                    anchor.addChild(fallback)
                }
            }
        } update: { content in
            // Hover tick
            for entity in content.entities {
                if var hover = entity.components[HoverComponent.self] {
                    hover.t += 0.01
                    entity.position.y = hover.baseY + sin(hover.t) * 0.03
                    entity.components[HoverComponent.self] = hover
                }
            }
        }
    }

    /// Tries main bundle first; then RealityKitContent bundle.
    /// Tries to load "butterfly.usdz" from the main app bundle.
    private func loadButterflyEntity() async -> Entity? {
        // Try common locations (root, Models/, Resources/)
        let candidates: [(name: String, ext: String, subdir: String?)] = [
            ("monarch", "usdz", nil),
            ("monarch", "usdz", "Models"),
            ("monarch", "usdz", "Resources")
        ]

        for c in candidates {
            if let url = Bundle.main.url(forResource: c.name, withExtension: c.ext, subdirectory: c.subdir),
               let e = try? await Entity(contentsOf: url) {
                return e
            }
        }

        // Last-resort: build a direct URL under the bundle’s resource root.
        if let base = Bundle.main.resourceURL {
            let url = base.appendingPathComponent("butterfly.usdz")
            if let e = try? await Entity(contentsOf: url) { return e }
        }
        return nil
    }

}

// Lightweight hover system
struct HoverComponent: Component { var baseY: Float; var t: Float = 0 }
extension Entity {
    func tickHover() {
        guard var comp = components[HoverComponent.self] else { return }
        comp.t += 0.01
        position.y = comp.baseY + sin(comp.t) * 0.03
        components[HoverComponent.self] = comp
    }
}
