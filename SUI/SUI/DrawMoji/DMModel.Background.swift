//
//  DMModel.Background.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import Foundation

extension DMModel {
    enum BackgroundCodingKeys: String, CodingKey {
        case backgroundURL
        case imageData
    }
    
    enum Background: Equatable, Codable {
        case blank
        case url(URL)
        case imageData(Data)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: BackgroundCodingKeys.self)
            if let url = try? container.decode(URL.self, forKey: .backgroundURL) {
                self = .url(url)
            } else if let imageData = try? container.decode(Data.self, forKey: .imageData) {
                self = .imageData(imageData)
            } else {
                self = .blank
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: BackgroundCodingKeys.self)
            switch self {
            case .url(let url): 
                try container.encode(url, forKey: .backgroundURL)
            case .imageData(let data): 
                try container.encode(data, forKey: .imageData)
            case .blank:
                break
            }
        }
        
        var url: URL? {
            switch self {
            case .url(let url): return url
            default: return nil
            }
        }
        
        var imageData: Data? {
            switch self {
            case .imageData(let data): return data
            default: return nil
            }
        }
    }
}
