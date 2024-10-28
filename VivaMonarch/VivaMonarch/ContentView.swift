import SwiftUI
import RealityKit
import AVFoundation

struct ContentView: View {

    var viewModel: ViewModel
    @Environment(Title.self) private var model

    @State private var currentImmersiveSpace: String? = nil
    @State private var showImmersiveSpace = false
    @State private var showImmersiveSpaceGallery = false
    @State private var showImmersiveSpaceAmerica = false
    @State private var showVieModelBeginning = false
    @State private var sliderValue: Double = 0 // Slider state variable
    @State private var audioPlayer: AVAudioPlayer?

    var baseYear: Int = 2024

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    private func playSound(named soundFileName: String) {
        guard let path = Bundle.main.path(forResource: soundFileName, ofType: nil) else { return }
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Could not load file")
        }
    }

    var body: some View {
        @Bindable var model = model

        NavigationStack {
            VStack {
                Text(model.finalTitle)
                    .monospaced()
                    .font(.system(size: 50, weight: .bold))
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
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
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    VStack {
                        Toggle(isOn: $showImmersiveSpace) {
                            HStack {
                                Image("Migration")
                                    .resizable()
                                    .frame(width: 140, height: 140)
                                    .cornerRadius(15)
                            }
                        }
                        .toggleStyle(.button)
                        .buttonStyle(.plain) // Apply plain style here
                       
                    }

                    .padding()

                    VStack {
                        Toggle(isOn: $showImmersiveSpaceGallery) {
                            HStack {
                                Image("PhotoGallery") // Ensure the image has a transparent background
                                    .resizable()
                                    .frame(width: 140, height: 140)
                            }
                            .cornerRadius(15)
                        }
                        .toggleStyle(.button)
                        .buttonStyle(.plain)
                        
                    }
                    .padding()

                    VStack {
                        Toggle(isOn: $showImmersiveSpaceAmerica) {
                            HStack {
                                Image("USButterflies") // Ensure the image has a transparent background
                                    .resizable()
                                    .frame(width: 140, height: 140)
                            }
                            .cornerRadius(15)
                        }
                        .toggleStyle(.button)
                        .buttonStyle(.plain)
                    }
                    .padding()

                    VStack {
                        Link(destination: URL(string: "https://www.instagram.com/stei.jan/")!) {
                            HStack {
                                Image("Instagram") // Ensure the image has a transparent background
                                    .resizable()
                                    .frame(width: 140, height: 140)
                            }
                            .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()

                    VStack {
                        Button(action: {
                            playSound(named: "StartArea.wav")
                        }) {
                            HStack {
                                Image("VideoGallery") // Ensure the image has a transparent background
                                    .resizable()
                                    .frame(width: 140, height: 140)
                            }
                            .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.clear)

                // Aesthetic Slider Section
//                VStack(spacing: 10) {
//                    Slider(value: $sliderValue, in: -100...100, step: 1)
//                        .padding(.horizontal, 20)
//                        .accentColor(.blue)
//                        .frame(maxWidth: 300)
//                    Text("Current year: \(String(Int(sliderValue) + baseYear))")
//                        .padding(.top, 5)
//                        .font(.headline)
//                }
//                .padding()
//                .background(Color.gray.opacity(0.1))
//                .cornerRadius(10)
//                .padding(.top, 20)
            }
            .typeText(
                text: $model.titleText,
                finalText: model.finalTitle,
                isFinished: $model.isTitleFinished,
                isAnimated: !model.isTitleFinished
            )
            .animation(.default.speed(0.25), value: model.isTitleFinished)
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            switchImmersiveSpace(newValue, id: "ImmersiveSpace")
        }
        .onChange(of: showImmersiveSpaceGallery) { _, newValue in
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceGallery")
        }
        .onChange(of: showImmersiveSpaceAmerica) { _, newValue in
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceAmerica")
        }
        .onChange(of: showVieModelBeginning) { _, newValue in
            switchImmersiveSpace(newValue, id: "showVieModelBeginning")
        }
        .onAppear {
               // Automatically trigger the immersive space for showVieModelBeginning
               showVieModelBeginning = true
           }
    }

    private func switchImmersiveSpace(_ newValue: Bool, id: String) {
        Task {
            if newValue {
                if let currentSpace = currentImmersiveSpace, currentSpace != id {
                    await dismissImmersiveSpace()
                    currentImmersiveSpace = nil
                }
                await openImmersiveSpace(id: id)
                currentImmersiveSpace = id
            } else {
                await dismissImmersiveSpace()
                currentImmersiveSpace = nil
            }
        }
    }
}


struct NoHoverButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Optional: slight scale effect on press
            .background(Color.clear) // Ensure no background is added
    }
}


#Preview {
    ContentView(viewModel: ViewModel())
}
