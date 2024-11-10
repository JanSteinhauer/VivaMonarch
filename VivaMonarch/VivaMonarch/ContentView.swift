import SwiftUI
import RealityKit
import AVFoundation

struct ContentView: View {

    var viewModel: ViewModel
    @Environment(Title.self) private var model

    @State private var currentImmersiveSpace: String? = nil
    @State private var showImmersiveSpace = false
    @State private var showImmersiveSpaceGallery = false
    @State private var showImmersiveSpaceVideoGallery = false
    @State private var showImmersiveSpaceAmerica = false
    @State private var showVieModelBeginning = false
    @State private var showVieModelWhales = false
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

    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
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
                        Toggle(isOn: $showVieModelBeginning) {
                            HStack {
                                Image("Migration")
                                    .resizable()
                                    .frame(width: 140, height: 140)
                                    .cornerRadius(15)
                            }
                        }
                        .toggleStyle(.button)
                        .buttonStyle(.plain)
                    }
                    .padding()

                    VStack {
                        Toggle(isOn: $showImmersiveSpaceGallery) {
                            HStack {
                                Image("PhotoGallery")
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
                        Toggle(isOn: $showVieModelWhales) {
                            HStack {
                                Image("Migration")
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
                                Image("USButterflies")
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
                                Image("Instagram")
                                    .resizable()
                                    .frame(width: 140, height: 140)
                            }
                            .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()

                    VStack {
                        Toggle(isOn: $showImmersiveSpaceVideoGallery) {
                            HStack {
                                Image("VideoGallery")
                                    .resizable()
                                    .frame(width: 140, height: 140)
                            }
                            .cornerRadius(15)
                        }
                        .toggleStyle(.button)
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.clear)
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
            switchImmersiveSpace(newValue, id: "ImmersiveSpace", soundFileName: "Introduction.wav")
        }
        .onChange(of: showImmersiveSpaceGallery) { _, newValue in
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceGallery")
        }
        .onChange(of: showImmersiveSpaceVideoGallery) { _, newValue in
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceVideoGallery")
        }
        .onChange(of: showImmersiveSpaceAmerica) { _, newValue in
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceAmerica")
        }
        .onChange(of: showVieModelBeginning) { _, newValue in
            switchImmersiveSpace(newValue, id: "showVieModelBeginning", soundFileName: "Animal.wav")
        }
        .onChange(of: showVieModelWhales) { _, newValue in
            switchImmersiveSpace(newValue, id: "showVieModelWhales")
        }
        .onAppear {
            showImmersiveSpace = true
        }
    }

    private func switchImmersiveSpace(_ newValue: Bool, id: String, soundFileName: String? = nil) {
        Task {
            if newValue {
                if let currentSpace = currentImmersiveSpace, currentSpace != id {
                    stopAudio() // Stop audio before switching immersive space
                    await dismissImmersiveSpace()
                    currentImmersiveSpace = nil
                }
                await openImmersiveSpace(id: id)
                currentImmersiveSpace = id
                if let soundFileName = soundFileName {
                    playSound(named: soundFileName)
                } else {
                    stopAudio()
                }
            } else {
                stopAudio() // Stop audio when leaving immersive space
                await dismissImmersiveSpace()
                currentImmersiveSpace = nil
            }
        }
    }
}

struct NoHoverButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .background(Color.clear)
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
