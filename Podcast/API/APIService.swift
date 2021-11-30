//
//  APIService.swift
//  Podcast
//
//  Created by Macbook on 11/30/21.
//

import Foundation
import Alamofire

class APIService {
    // singleton
    static let shared = APIService()
    let baseiTunesURL = "https://itunes.apple.com/search"
    
    
    func fetchPodcast(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        print("Searching for podcasts...")
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(baseiTunesURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { dataResponse in
            if let err = dataResponse.error {
                print("Failed to contact yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
                        
            do {
                print(3)
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                completionHandler(searchResult.results)
                
//                self.podcasts = searchResult.results
//                self.tableView.reloadData()

            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
            
        }
        
        print(2)
    }
    
    // MARK: - Search Result Struct
    struct SearchResults: Decodable {
        let resultCount: Int
         
        let results: [Podcast]
        
    }

    
}
