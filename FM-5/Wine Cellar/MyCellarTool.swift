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


import Foundation
import FoundationModels

@Observable
final class MyCellarTool: Tool {
    let name = "cellarTool"
    let description = "Find information from your wine cellar on the specified variety"
    let wines: [Wine]
    
    init(wines: [Wine]) {
        self.wines = wines
    }
    @Generable
    struct Arguments {
        @Guide(description: "The variety to look for.")
        let variety: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let foundWines = wines.filter {$0.variety == arguments.variety}
        let totalInStock = foundWines
            .flatMap { $0.vintages }   // Flatten all vintages across wines
            .map { $0.inStock }        // Extract the inStock value
            .reduce(0, +)              // Sum them up
        let wineries = foundWines.map({$0.winery})
        let wineriesWithStock = Set(
            wines
                .filter { $0.variety == arguments.variety && $0.vintages.contains { $0.inStock > 0 } }
                .map { $0.winery }
        )
        let countries = Set(foundWines.map({$0.country}))
        return """
            Your cellar has contained \(arguments.variety) from from the following wineries: \(wineries.joined(separator: ", ")).
            The different countries of origin are \(countries.joined(separator: ", ")).
            You have \(totalInStock) wines of the variety \(arguments.variety) in stock.
            These wines come from \(wineriesWithStock.joined(separator: ", ")).
            """
    }
}
