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

struct Wine: Codable {
  var country: String
  var id: String
  var name: String
  var region: String
  var variety: String
  var vintages: [Vintage]
  var winery: String
}

struct Vintage: Codable {
  var inStock: Int
  var price: Double
  var year: Int
}
