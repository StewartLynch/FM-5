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

enum MyTabs: String, CaseIterable, View {
    case guided = "Wine Types"
    case guided2 = "Cellar Advisor"
    
    var id: Self { self }
    var body: some View {
        switch self {
        case .guided:
            WineTypesView()
        case .guided2:
            CellarAvisor()
        }
    }
}


struct StartTab: View {
    @Environment(NavManager.self) var navManager
    var body: some View {
        @Bindable var navManager = navManager
        TabView(selection: $navManager.selectedTab) {
            ForEach(MyTabs.allCases.indices, id: \.self) { index in
                let tab = MyTabs.allCases[index]
                Tab(
                    tab.rawValue,
                    systemImage: "\(index + 1).circle",
                    value: tab) {
                        tab
                    }
            }
        }
    }
}

#Preview {
    StartTab()
        .environment(NavManager())
        .environment(FoundationManager())
        .environment(CellarManager())
}
