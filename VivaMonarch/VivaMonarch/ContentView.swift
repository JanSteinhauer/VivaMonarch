import SwiftUI
import RealityKit

struct ContentView: View {

    var viewModel: ViewModel

    @State private var showImmersiveSpace = false
    @State private var showImmersiveSpaceGallery = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                    .toggleStyle(.button)
                Toggle("Show ImmersiveGallery", isOn: $showImmersiveSpaceGallery)
                    .toggleStyle(.button)
            }
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
        .onChange(of: showImmersiveSpaceGallery) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "showImmersiveSpaceGallery")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
