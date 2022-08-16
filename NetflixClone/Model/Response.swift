//
//  Response.swift
//  InstaClone
//
//  Created by Iksang Yoo on 2022/08/15.
//

import Foundation

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}
