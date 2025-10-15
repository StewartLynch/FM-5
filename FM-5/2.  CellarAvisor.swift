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
    @State private var session: LanguageModelSession?
    @State private var responseContent = ""
    let instructions = Instructions {
        "Use the 'cellarTool' when the prompt asks for infomation from the cellar regarding a wine variety."
        "For all other questions, only allow questions about wine."
    }
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
                                      guard let session else { return }
                                      if !question.isEmpty {
                                          let prompt = question.trimmingCharacters(in: .whitespacesAndNewlines)
                                          let stream = session.streamResponse(to: prompt)
                                          Task {
                                              for try await partialResponse in stream {
                                                  responseContent = manager.minimizeMarkDown(partialResponse.content)
                                              }
                                          }
                                      }
                                  }
                              if !question.isEmpty {
                                  Button {
                                      question = ""
                                  } label: {
                                      Image(systemName: "xmark.circle.fill")
                                          .foregroundStyle(.secondary)
                                  }
                                  .disabled(session?.isResponding == true)
                              }
                          }
                      }
                      .padding()
                      .overlay {
                          if session?.isResponding == true {
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
                          question = ""
                          responseContent = ""
                          session = LanguageModelSession(tools: [MyCellarTool(wines: cellarManager.wines)], instructions: instructions)
                      }
                      .disabled(session?.isResponding == true || responseContent.isEmpty)
                  }
              }
          }
          .onChange(of: scenePhase) { _, newPhase in
              if newPhase == .active {
                  manager.checkIsAvailable()
              }
          }
          .task {
              if session == nil {
                  session = LanguageModelSession(tools: [MyCellarTool(wines: cellarManager.wines)], instructions: instructions)
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

