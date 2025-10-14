//
//----------------------------------------------
// Original project: FM-5
// by  Stewart Lynch on 2025-10-12
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

struct CellarAvisor: View {
    @Environment(NavManager.self) var navManager
    @Environment(FoundationManager.self) var manager
    @Environment(CellarManager.self) var cellarManager
    @Environment(\.scenePhase) var scenePhase
    @State private var question = ""
    @State private var session = LanguageModelSession()
    @State private var responseContent = ""

      var body: some View {
          NavigationStack{
              Group {
                  if manager.isModelAvailable {
                      VStack {
                          if !responseContent.isEmpty {
                              ScrollView {
                                  Text(.init(responseContent))
                              }
                              .padding()
                          } else {
                              ContentUnavailableView("How can I help?", systemImage: "wineglass.fill", description: Text("I can answer questions about the varieties you have in your wine cellar."))
                          }
                          HStack(alignment: .firstTextBaseline, spacing: 8) {
                              TextField("Ask away ...", text: $question, axis: .vertical)
                                  .lineLimit(1...5)
                                  .textFieldStyle(.roundedBorder)
                                  .submitLabel(.send)
                                  .onSubmit {
                                      
                                  }
                              if !question.isEmpty {
                                  Button {
                                      question = ""
                                  } label: {
                                      Image(systemName: "xmark.circle.fill")
                                          .foregroundStyle(.secondary)
                                  }
                                  .disabled(session.isResponding )
                              }
                          }
                      }
                      .padding()
                      .overlay {
                          if session.isResponding {
                              ProgressView()
                          }
                      }
                  } else {
                      IntelligenceUnavailableView()
                  }
              }
              .navigationTitle(navManager.selectedTab.rawValue)
              .toolbarTitleDisplayMode(.inlineLarge)
              .toolbar {
                  if manager.isModelAvailable {
                      Button("New Session") {
                          
                      }
                      .disabled(session.isResponding || responseContent.isEmpty)
                  }
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
    CellarAvisor()
        .environment(FoundationManager())
        .environment(CellarManager())
        .environment(NavManager())
}

