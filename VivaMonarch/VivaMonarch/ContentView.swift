import SwiftUI
import RealityKit

struct ContentView: View {

    var viewModel: ViewModel
    @Environment(Title.self) private var model

    @State private var showImmersiveSpace = false
    @State private var showImmersiveSpaceGallery = false
    @State private var sliderValue: Double = 0 // Slider state variable

    var baseYear: Int = 2024

    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        @Bindable var model = model

        NavigationStack {
            VStack {
                Text(model.finalTitle)
                    .monospaced()
                    .font(.system(size: 50, weight: .bold))
                    .padding(.horizontal, 40)
                    .hidden()
                    .overlay(alignment: .leading) {
                        Text(model.titleText)
                            .monospaced()
                            .font(.system(size: 50, weight: .bold))
                            .padding(.leading, 40)
                    }
                Text("Start your journey NOW")
                    .font(.title)
                    .opacity(model.isTitleFinished ? 1 : 0)
                Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                    .toggleStyle(.button)
                Toggle("Show ImmersiveGallery", isOn: $showImmersiveSpaceGallery)
                    .toggleStyle(.button)
                Link(destination: URL(string: "https://www.instagram.com/stei.jan/")!) {
                                  Text("Show Instagram")
                                      .foregroundColor(.white)
                                      .padding()
                                      .background(Color.gray.opacity(0.2))
                                      .cornerRadius(5)
                              }
                
             
                  
               
                Slider(value: $sliderValue, in: -10...10, step: 1)
                                   .padding()
                               
                Text("Current year: \(String(Int(sliderValue) + baseYear))")
                                    .padding()
            }
            .typeText(
                text: $model.titleText,
                finalText: model.finalTitle,
                isFinished: $model.isTitleFinished,
                isAnimated: !model.isTitleFinished)
            .animation(.default.speed(0.25), value: model.isTitleFinished)
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
