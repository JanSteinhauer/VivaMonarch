import SwiftUI
import RealityKit
import AVFoundation

enum ChartType {
    case none
    case population
    case migration
}


struct ContentView: View {
    
    @Bindable var viewModel: ViewModel
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
    @State private var showChartView = false // New state variable to control chart visibilit
    @State private var selectedChart: ChartType = .none
    
    
    var baseYear: Int = 2024
    
    let MonarchURL = "https://firebasestorage.googleapis.com/v0/b/vivamonarch-b34f3.appspot.com/o/Monarch6.mp4?alt=media&token=b8b6bb34-ce96-426e-9c03-ee2947883e94"
    let WhalesURL = "https://firebasestorage.googleapis.com/v0/b/greenshiftai.appspot.com/o/Whale%20North%20Sunset%20Final%20A.mp4?alt=media&token=68d4186f-2ccb-4740-b423-de77e0a805be"
    let CreditsURL = "https://firebasestorage.googleapis.com/v0/b/greenshiftai.appspot.com/o/Butterflies%20Blue%20Sky_1.mp4?alt=media&token=383bcdec-db25-4d69-8120-506b8c9a1b4c"
    
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    private func playSound(named soundFileName: String) {
        stopAudio() // Stop previous audio
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
                
                if selectedChart != .none {
                    VStack {
                        switch selectedChart {
                        case .population:
                            Text("Monarch Butterfly Population Over Years")
                                .font(.system(size: 40))
                                .padding(.top)
                            
                            PopulationChartView()
                                .frame(height: 300)
                            
                        case .migration:
                            Text("Migration Distance by Region")
                                .font(.headline)
                                .padding(.top)
                            
                            MigrationChartView()
                                .frame(height: 300)
                            
                        default:
                            EmptyView()
                        }
                        
                        Button(action: {
                            selectedChart = .none
                        }) {
                            Text("Back")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                } else {
                    // Display the grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        VStack {
                            Button(action: {
                                selectedChart = .population
                                stopAudio()
                                viewModel.urlString = WhalesURL
                                Task {
                                    await openCommonImmersiveSpace()
                                }
                            }) {
                                HStack {
                                    Image("Migration")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .cornerRadius(15)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        
                        // Other grid items...
                        
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
                            Button(action: {
                                stopAudio()
                                viewModel.urlString = CreditsURL
                                Task {
                                    await openCommonImmersiveSpace()
                                }
                            }) {
                                HStack {
                                    Image("Instagram")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .cornerRadius(15)
                                }
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
            selectedChart = .migration
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceAmerica")
        }
        .onChange(of: showVieModelBeginning) { _, newValue in
            switchImmersiveSpace(newValue, id: "showVieModelBeginning", soundFileName: "Animal.wav")
        }
        .onAppear  {
            viewModel.urlString = MonarchURL
            Task {
                await openCommonImmersiveSpace()
                playSound(named: "Animal.wav")
            }
        }
    }

    private func openCommonImmersiveSpace() async {
        if currentImmersiveSpace != "CommonImmersiveSpace" {
            if let currentSpace = currentImmersiveSpace {
                await dismissImmersiveSpace()
            }
            await openImmersiveSpace(id: "CommonImmersiveSpace")
            currentImmersiveSpace = "CommonImmersiveSpace"
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
