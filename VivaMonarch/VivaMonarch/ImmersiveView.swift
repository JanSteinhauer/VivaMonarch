import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Bindable var viewModel: ViewModel

    @State private var effectEnabled = true
    @State private var strength: Float = 0

    var body: some View {
        ZStack {
            RealityView { content in
                content.add(viewModel.setupContentEntity())
            }
            .id(viewModel.urlString ?? UUID().uuidString) 
            .onAppear() {
                viewModel.play()
            }
            .onDisappear() {
                viewModel.pause()
            }

            // Overlaying the DigitalRain effect on top of the RealityView
//            DigitalRain()
//                .gesture(
//                    SpatialTapGesture()
//                        .onEnded { event in
//                            effectEnabled.toggle()
//                            strength = effectEnabled ? 10 : 0
//                        }
//                )
//                .opacity(effectEnabled ? 1 : 0) // Control visibility based on effectEnabled
                // .layerEffect not available in RealityKit, this is just to illustrate the idea
                // .layerEffect(ShaderLibrary.pixellate(.float(strength)), maxSampleOffset: .zero)
        }
    }
}

// Assume there's a ViewModel class defined elsewhere
// Assume DigitalRain is a custom SwiftUI View that you have created

struct ImmersiveView_Previews: PreviewProvider {
    static var previews: some View {
        ImmersiveView(viewModel: ViewModel())
            .previewLayout(.sizeThatFits)
    }
}
