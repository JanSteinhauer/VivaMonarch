import SwiftUI
import RealityKit
import AVFoundation

struct ContentView: View {
    @Bindable var viewModel: ViewModel
    @Environment(Title.self) private var model
    
    @StateObject private var audio = AudioManager()
    @State private var activeSpace: ActiveSpace = .common
    @State private var selectedChart: ChartType = .none
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
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
                    if selectedChart == .aiMonarch {
                        MonarchAIChatView()
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        
                    }else {
                        ChartBoardView(
                            selectedChart: $selectedChart,
                            monarch: Datasets.monarch,
                            whale: Datasets.whale,
                            turtle: Datasets.turtle,
                            condor: Datasets.condor
                        )
                    }
                    
                } else {
                    HubGrid(
                        onOpenAmerica: { route(to: .america) { selectedChart = .migration } },
                        onOpenGallery: { route(to: .gallery) { audio.playSound(named: Sounds.ambient) } },
                        onOpenBeginning: { route(to: .beginning) { audio.playSound(named: Sounds.animal) } },
                        onOpenMonarchHome: {
                            audio.stopAudio()
                            selectedChart = .butterflyhub
                            viewModel.urlString = Media.monarch
                            route(to: .common) { audio.playSound(named: Sounds.ambient) }
                        },
                        onOpenCredits: {
                            audio.stopAudio()
                            selectedChart = .credits
                            viewModel.urlString = Media.credits
                            route(to: .common)
                        },
//                        onOpenBonus: {
//                            selectedChart = .population
//                            audio.stopAudio()
//                            viewModel.urlString = Media.whales
//                            route(to: .common)
//                        },
                        onOpenAIMonarch: {
                            audio.stopAudio()
                            selectedChart = .aiMonarch
                            route(to: .common)
                        }
                    )
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
        // Centralized routing
        .onChange(of: activeSpace) { _, newSpace in
            Task { await handle(space: newSpace) }
        }
        .onAppear {
            // Initial route + intro audio
            viewModel.urlString = Media.monarch
            Task { await handle(space: .common); audio.playSound(named: Sounds.intro)}
        }
    }
    
    // MARK: - Routing helpers
    
    private func route(to space: ActiveSpace, after: (() -> Void)? = nil) {
        activeSpace = space
        after?()
    }
    
    private func immersiveID(for space: ActiveSpace) -> String? {
        switch space {
        case .none:         return nil
        case .common:       return SpaceID.common
        case .gallery:      return SpaceID.gallery
        case .videoGallery: return SpaceID.videoGallery
        case .america:      return SpaceID.america
        case .beginning:    return SpaceID.beginning
        case .aiMonarchImmersive: return SpaceID.monarchSpace
        }
    }
    
    private func handle(space: ActiveSpace) async {
        // Dismiss any existing, then open the new one.
        await dismissImmersiveSpace()
        guard let id = immersiveID(for: space) else { return }
        await openImmersiveSpace(id: id)
    }
}
