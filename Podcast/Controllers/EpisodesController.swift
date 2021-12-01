//
//  EpisodesController.swift
//  Podcast
//
//  Created by Macbook on 12/1/21.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        guard let url = URL(string: feedUrl) else { return }
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { (res) in
            
            switch res {
            case .success(let feed):
                           
                switch feed {
                case let .rss(feed):
                    var episodes = [Episode]() // blank
                    
                    feed.items?.forEach({ feedItem in
                        let episode = Episode(title: feedItem.title ?? "" )
                        episodes.append(episode)
                    })
                    
                    self.episodes = episodes
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    break
                    
                default:
                    break
                }
                
            case .failure(let failure):
                print(failure)
            }
            
        }
        
    }
    
    fileprivate let cellId = "cellId"
    
    struct Episode {
        var title: String
    }
    
    var episodes = [
        Episode(title: "First Episode"),
        Episode(title: "Second"),
        Episode(title: "Third")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWork()
        
    }
    
    //MARK: - Setup Work {
    fileprivate func setupWork() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    
    //MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = episodes[indexPath.row].title
        
        return cell
    }
    
    
    
    
    
    
}
