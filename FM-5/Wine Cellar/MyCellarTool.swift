//
//----------------------------------------------
// Original project: FM-5
// by  Stewart Lynch on 2025-10-15
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

struct MyCellarTool: Tool {
    let name: String = "cellarTool"
    let description: String = "Find information from your wine cellar on the specified variety"
    let wines: [Wine]
    
    @Generable
    struct Arguments {
        @Guide(description: "")
        let variety: String
    }
    
    func call(arguments: Arguments) async throws -> String {
        let foundWines = wines.filter {$0.variety == arguments.variety}
        let totalInStock = foundWines
            .flatMap({$0.vintages})
            .map {$0.inStock}
            .reduce(0,+)
        let foundWineries = Array(Set(foundWines.map {$0.winery}))
        let wineriesWithStock = Array(Set(wines.filter {$0.variety == arguments.variety && $0.vintages.contains {$0.inStock > 0}}
            .map {$0.winery}))
        let countries = Array(Set(foundWines.map {$0.country}))
        return """
            Your cellar contains \(arguments.variety) from the following wineries: \(foundWineries.joined(separator: ", "))
            The different countries of origin of the variety are \(countries.joined(separator: ", "))
            You have \(totalInStock) wines of the variety \(arguments.variety) in stock.
            These wines in stock come from \(wineriesWithStock.joined(separator: ", "))
            """
    }
}
