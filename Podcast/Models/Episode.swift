//
//  Episode.swift
//  Podcast
//
//  Created by Macbook on 12/2/21.
//

import Foundation
import FeedKit

struct Episode {
    var title: String
    var pubDate: Date
    var description: String
    
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
    
}
