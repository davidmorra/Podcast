//
//  Podcast.swift
//  Podcast
//
//  Created by Macbook on 11/29/21.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
