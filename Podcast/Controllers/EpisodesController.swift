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
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { episodes in
            self.episodes = episodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        
    }
    
    fileprivate let cellId = "cellId"
    
    
    var episodes = [Episode]()
    
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWork()
        
    }
    
    //MARK: - Setup Work {
    fileprivate func setupWork() {
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    //MARK: - UITableView Section
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
                
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell

        cell.episode = episodes[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        let window = UIApplication.keyWindow
        let mainTabController = window?.rootViewController as? MainTabBarController
        mainTabController?.maximazePlayerDelail(episode: episode)
        
        
//
//        let playerDetailView = PlayerDetailView.initFromNib()
//        playerDetailView.episode = episode
//        playerDetailView.frame = self.view.frame
//
//        let window = UIApplication.shared.keyWindow
//        window?.addSubview(playerDetailView)
    }
}
