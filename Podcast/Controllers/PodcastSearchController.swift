//
//  PodcastSearchController.swift
//  Podcast
//
//  Created by Macbook on 11/29/21.
//

import UIKit
import Alamofire

class PodcastSearchController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [
        Podcast(trackName: "Kuji Podcast", artistName: "Kuji"),
        Podcast(trackName: "History of Rome in 20 minutes", artistName: "Arzamas"),
        Podcast(trackName: "Ancient Greece in 20 minutes", artistName: "Arzamas")

    ]

    let cellID = "cellID"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    
    
    // MARK: - Setup Work
    fileprivate func setupTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    
    // MARK: - Search Bar + Alamofire Request
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(1)
        APIService.shared.fetchPodcast(searchText: searchText) { podcasts in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }

    }
    
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        
        
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        
        
//        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
//        cell.textLabel?.numberOfLines = -1
//        cell.imageView?.image = UIImage(systemName: "photo")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    
}
