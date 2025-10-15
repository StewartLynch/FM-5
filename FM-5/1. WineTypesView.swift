//
//----------------------------------------------
// Original project: FM-5
// by  Stewart Lynch on 2025-10-14
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.



import SwiftUI
import FoundationModels

@Generable
struct GeneratedWine: Identifiable {
    let id = UUID()
    let variety: String
    
    @Guide(description: "The type of wine (Red, White, Sparkling, Rosé, Dessert")
    let type: String
}

struct WineTypeTool: Tool {
    let name = "wineType"
    let description: String = "Determine the type of wine."
    let varieties: [String]
    @Generable
    struct Arguments {
        @Guide(description: "The number of varieties to select")
        let varietyCount: Int
    }
    
    func call(arguments: Arguments) async throws -> GeneratedContent {
        let sampleArray = Array(varieties.shuffled().prefix(arguments.varietyCount))
        return GeneratedContent(properties: ["wines": sampleArray])
    }
}

struct WineTypesView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(NavManager.self) var navManager
    @Environment(FoundationManager.self) var manager
    @Environment(CellarManager.self) var cellar
    
    @State private var wineCount = 1
    @State private var session: LanguageModelSession?
    @State private var generatedWines: [GeneratedWine] = []
    var body: some View {
        NavigationStack {
            if manager.isModelAvailable {
                Form {
                    Text("Choose a the number of varieties to fetch from your cellar and determine the type.")
                    Stepper(value: $wineCount, in: (cellar.varieties.isEmpty ? 0 : 1)...max(0,cellar.varieties.count)) {
                        Text("Number of wines: \(wineCount)")
                    }
                    .disabled(cellar.varieties.isEmpty)
                    Button("Get types") {
                        generatedWines.removeAll()
                        let prompt = "Use the 'wineType' tool to select \(wineCount) varieties and determine the type."
                        session = LanguageModelSession(tools: [WineTypeTool(varieties: cellar.varieties)])
                        Task {
                            guard let session else { return }
                            generatedWines = try await session.respond(to: prompt, generating: [GeneratedWine].self).content
                        }
                    }
                    .disabled(session?.isResponding == true || cellar.varieties.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    ForEach(generatedWines) { wine in
                        Text("\(wine.variety) (\(wine.type))")
                    }
                }
                .overlay {
                    if session?.isResponding == true {
                        ProgressView()
                    }
                }
                .navigationTitle(navManager.selectedTab.rawValue)
            } else {
                IntelligenceUnavailableView()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                manager.checkIsAvailable()
            }
        }
    }
}

#Preview {
    WineTypesView()
        .environment(NavManager())
        .environment(FoundationManager())
        .environment(CellarManager())
}
