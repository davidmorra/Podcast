//
//  APIService.swift
//  Podcast
//
//  Created by Macbook on 11/30/21.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl) else { return }
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { (res) in
            
            switch res {
            case .success(let feed):

                guard let feed = feed.rssFeed else { return }
                
                let episodes = feed.tpEpisodes()
                completionHandler(episodes)
                
            case .failure(let failure):
                print(failure)
            }
            
        }
    }
    
    
    let baseiTunesURL = "https://itunes.apple.com/search"
    
    func fetchPodcast(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(baseiTunesURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
                        
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                completionHandler(searchResult.results)

            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
            
        }
    }
    
    // MARK: - Search Result Struct
    struct SearchResults: Decodable {
        let resultCount: Int
         
        let results: [Podcast]
        
    }
}
