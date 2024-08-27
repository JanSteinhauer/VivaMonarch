import SwiftUI
import RealityKit
import AVFoundation

struct ContentView: View {

    var viewModel: ViewModel
    @Environment(Title.self) private var model

    @State private var showImmersiveSpace = false
    @State private var showImmersiveSpaceGallery = false
    @State private var showImmersiveSpaceAmerica = false
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
                ], spacing: 10) {  // Increased spacing between items for better visual separation
                    VStack {
                        Toggle(isOn: $showImmersiveSpace) {
                            HStack {
                                Text("🔲")
                                    .font(.system(size: 40))  // Slightly larger emoji
                                Text("Immersive Space")
                                    .font(.system(size: 22))  // Larger text for clarity
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .toggleStyle(.button)
                    }
                    .padding()

                    VStack {
                        Toggle(isOn: $showImmersiveSpaceGallery) {
                            HStack {
                                Text("🖼️")
                                    .font(.system(size: 40))
                                Text("Gallery")
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                            }
                          
                            .padding()
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .toggleStyle(.button)
                    }
                    .padding()

                    VStack {
                        Toggle(isOn: $showImmersiveSpaceAmerica) {
                            HStack {
                                Text("🇺🇸")
                                    .font(.system(size: 40))
                                Text("Butterflies through America")
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .toggleStyle(.button)
                    }
                    .padding()

                    VStack {
                        Link(destination: URL(string: "https://www.instagram.com/stei.jan/")!) {
                            HStack {
                                Text("📷")
                                    .font(.system(size: 40))
                                Text("Instagram")
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(.gray.opacity(0.2))
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()

                    VStack {
                        Button(action: {
                            playSound(named: "StartArea.wav")
                        }) {
                            HStack {
                                Text("▶️")
                                    .font(.system(size: 40))
                                Text("Start Audioguide")
                                    .font(.system(size: 22))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                    }
                  
                }
                .padding()
                .background(Color.clear)


                // Aesthetic Slider Section
                VStack(spacing: 10) {
                    Slider(value: $sliderValue, in: -100...100, step: 1)
                        .padding(.horizontal, 20)
                        .accentColor(.blue) // Change slider color
                        .frame(maxWidth: 300) // Limit the width of the slider
                    Text("Current year: \(String(Int(sliderValue) + baseYear))")
                        .padding(.top, 5)
                        .font(.headline)
                }
                .padding()
                .background(Color.gray.opacity(0.1)) // Background color for the slider section
                .cornerRadius(10)
                .padding(.top, 20)
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
        .onChange(of: showImmersiveSpaceAmerica) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "showImmersiveSpaceAmerica")
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
