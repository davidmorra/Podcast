//
//  RSSFeed.swift
//  Podcast
//
//  Created by Macbook on 12/2/21.
//

import FeedKit

extension RSSFeed {
    func tpEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes = [Episode]() // blank
        
        items?.forEach({ feedItem in
            var episode = Episode(feedItem: feedItem)
            
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            
            
            episodes.append(episode)
        })
        
        
        return episodes
    }
}
