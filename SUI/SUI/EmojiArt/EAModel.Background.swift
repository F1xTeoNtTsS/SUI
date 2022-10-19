//
//  EAModel.Background.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import Foundation

extension EAModel {
    enum Background {
        case blank
        case url(URL)
        case imageData(Data)
        
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
