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


struct WineTypesView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(NavManager.self) var navManager
    @Environment(FoundationManager.self) var manager
    @Environment(CellarManager.self) var cellar
    
    @State private var wineCount = 1
    @State private var session = LanguageModelSession()
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
                        
                    }
                    .disabled(session.isResponding || cellar.varieties.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                .overlay {
                    if session.isResponding {
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
