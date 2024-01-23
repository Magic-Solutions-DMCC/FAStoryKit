// Copyright (c) 2024 Magic Solutions. All rights reserved.


import Foundation

struct MSStory {
    let name: String
    let previewAssetID: String
    let contents: [MSStoryContent]

    enum CodingKeys: String, CodingKey {
        case name
        case previewAssetID = "previewAssetId"
        case contents
    }
}

// MARK: - Decodable
extension MSStory: Decodable { }
