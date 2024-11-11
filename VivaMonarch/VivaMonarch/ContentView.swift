import SwiftUI
import RealityKit
import AVFoundation

enum ChartType {
    case none
    case population
    case migration
    case butterflyhub
    case credits
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
    
    let monarch_population = [
        PopulationData(year: 2016, population: 84000000),
        PopulationData(year: 2017, population: 96600000),
        PopulationData(year: 2018, population: 186900000),
        PopulationData(year: 2019, population: 141400000),
        PopulationData(year: 2020, population: 99300000),
        PopulationData(year: 2021, population: 59640000),
        PopulationData(year: 2022, population: 58800000),
        PopulationData(year: 2023, population: 18900000)
    ]

    let whale_population = [
        PopulationData(year: 2016, population: 27000),
        PopulationData(year: 2017, population: 26500),
        PopulationData(year: 2018, population: 26000),
        PopulationData(year: 2019, population: 21000),
        PopulationData(year: 2020, population: 15000),
        PopulationData(year: 2021, population: 14000),
        PopulationData(year: 2022, population: 15000),
        PopulationData(year: 2023, population: 19000)
    ]

    let turtle_population = [
        PopulationData(year: 2016, population: 34000),
        PopulationData(year: 2017, population: 35000),
        PopulationData(year: 2018, population: 36000),
        PopulationData(year: 2019, population: 35000),
        PopulationData(year: 2020, population: 34000),
        PopulationData(year: 2021, population: 35000),
        PopulationData(year: 2022, population: 36000),
        PopulationData(year: 2023, population: 34000)
    ]

    let condor_population = [
        PopulationData(year: 2016, population: 446),
        PopulationData(year: 2017, population: 463),
        PopulationData(year: 2018, population: 488),
        PopulationData(year: 2019, population: 518),
        PopulationData(year: 2020, population: 504),
        PopulationData(year: 2021, population: 537),
        PopulationData(year: 2022, population: 561),
        PopulationData(year: 2023, population: 580)
    ]

    
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
                            Text("Population Over Years in Millions")
                                .font(.system(size: 40))
                                .padding(.top)
                            VStack{
                                HStack{
                                    VStack{
                                        Text("Monarch Butterfly")
                                            .font(.system(size: 20))
                                            .padding(.top)
                                        PopulationChartView(data: monarch_population)
                                            .frame(height: 100)
                                    }
                                   
                                    VStack{
                                        Text("Whale")
                                            .font(.system(size: 20))
                                            .padding(.top)
                                        PopulationChartView(data: whale_population)
                                            .frame(height: 100)
                                    }
                                       
                                }
                                HStack{
                                    VStack{
                                        Text("Turtle")
                                            .font(.system(size: 20))
                                            .padding(.top)
                                        PopulationChartView(data: turtle_population)
                                            .frame(height: 100)
                                    }
                                        
                                    VStack{
                                        Text("California condor")
                                            .font(.system(size: 20))
                                            .padding(.top)
                                        PopulationChartView(data: turtle_population)
                                            .frame(height: 100)
                                    }
                                       
                                }
                            }
                            .padding(.bottom)
//                            PopulationChartView()
//                                .frame(height: 300)
                            
                        case .migration:
                            Text("Migration Distance by Region")
                                .font(.system(size: 40))
                                .padding(.top)
                            
                            MigrationChartView()
                                .frame(height: 300)
                        case .credits:
                            Image("CreditsImage")
                                .frame(height: 300)
                        case .butterflyhub:
                            Text("Monarch Butterfly Population Over Years")
                                .font(.system(size: 40))
                                .padding(.top)
                            
                            PopulationChartView(data: monarch_population)
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
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        VStack {
                            Toggle(isOn: $showImmersiveSpaceAmerica) {
                                VStack {
                                    Image("AmericaMap")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                    Text("Journey America")
                                }
                                .cornerRadius(15)
                            }
                            .toggleStyle(.button)
                            .buttonStyle(.plain)
                        }
                        .padding()
                        
                        VStack {
                            Toggle(isOn: $showVieModelBeginning) {
                                VStack {
                                    Image("AnimalMigration")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                    Text("Animal Migration")
                                }
                                .cornerRadius(15)
                            }
                            .toggleStyle(.button)
                            .buttonStyle(.plain)
                        }
                        .padding()
                   
                        
                        VStack {
                            Toggle(isOn: $showImmersiveSpaceGallery) {
                                VStack {
                                    Image("GalleryIcon")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                    Text("Gallery")
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
                                selectedChart = .butterflyhub
                                viewModel.urlString = MonarchURL
                                Task {
                                    await openCommonImmersiveSpace()
                                    playSound(named: "AmbientSounds.mp3")
                                }
                            }) {
                                VStack {
                                    Image("MonarchMigration")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                    Text("Monarch Home")
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()

                        
                        
                        VStack {
                            Button(action: {
                                stopAudio()
                                viewModel.urlString = CreditsURL
                                selectedChart = .credits
                                Task {
                                    await openCommonImmersiveSpace()
                                }
                            }) {
                                VStack {
                                    Image("Credits")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                    Text("Credits")
                                }
                                
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        
                        
                        VStack {
                            Button(action: {
                                selectedChart = .population
                                stopAudio()
                                viewModel.urlString = WhalesURL
                                Task {
                                    await openCommonImmersiveSpace()
                                }
                            }) {
                                VStack {
                                    Image("Bonus")
                                        .resizable()
                                        .frame(width: 140, height: 140)
                                        .clipShape(Circle())
                                    Text("Bonus")
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()

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
            switchImmersiveSpace(newValue, id: "showImmersiveSpaceGallery", soundFileName: "AmbientSounds.mp3")
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
                playSound(named: "Introduction.wav")
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
