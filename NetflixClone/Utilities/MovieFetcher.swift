//
//  MovieFetcher.swift
//  InstaClone
//
//  Created by Iksang Yoo on 2022/08/15.
//

import Foundation
import UIKit

class MovieFetcher {
    static func fetch(_ type: RecommendListViewModel.RecommendingType) -> [DummyItem] {
        switch type {
        case .award:
            let movies = (1..<10).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .hot:
            let movies = (10..<19).map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        case .my:
            let movies = (1..<10).map { $0 * 2 }.map { DummyItem(thumbnail: UIImage(named: "img_movie_\($0)")!) }
            return movies
        }
    }
}
