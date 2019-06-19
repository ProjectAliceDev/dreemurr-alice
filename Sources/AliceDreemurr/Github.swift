//
//  File.swift
//  
//
//  Created by Marquis Kurt on 6/18/19.
//

import Foundation

public struct GithubRelease : GithubReleaseProtocol {
    var url: String
    var name: String
    var body: String
    var tag_name: String
}

public protocol GithubReleaseProtocol : Codable {
    init?(fromJson: String)
}

public extension GithubReleaseProtocol {
    init?(fromJson: String) {
        guard let data = fromJson.data(using: .utf8) else {
            return nil
        }
        
        self = try! JSONDecoder().decode(Self.self, from: data)
    }
}
