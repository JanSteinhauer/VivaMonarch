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

          
        }
    }
}

struct ImmersiveView_Previews: PreviewProvider {
    static var previews: some View {
        ImmersiveView(viewModel: ViewModel())
            .previewLayout(.sizeThatFits)
    }
}
