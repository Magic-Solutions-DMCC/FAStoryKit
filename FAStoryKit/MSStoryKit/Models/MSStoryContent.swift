// Copyright (c) 2024 Magic Solutions. All rights reserved.

import Foundation

struct MSStoryContent {
    let fileFormat: MSSFileFormat
    let fileName: String
    let externalURL: URL

    enum CodingKeys: String, CodingKey {
        case externalURL
    }
}

// MARK: - Decodable
extension MSStoryContent: Decodable { 

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let urlString = try? container.decode(String.self, forKey: .externalURL)
        if
            let externalURLString = urlString,
            let externalURL = URL(string: externalURLString),
            let fileFormat = MSSFileFormat(rawValue: externalURL.fileExtension) {
            self.externalURL = externalURL
            self.fileFormat = fileFormat
            self.fileName = externalURL.fileName
        } else {
            debugPrint("MSStoryContent: Decoding failed with url:", urlString ?? "")
            throw DecodingError.decodingFailed
        }

     }
}
