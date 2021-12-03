//
//  PlayerDetailView.swift
//  Podcast
//
//  Created by Macbook on 12/3/21.
//

import UIKit
import AVKit

class PlayerDetailView: UIView {
    
    var episode: Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "" ) else { return }
            episodeImageView.sd_setImage(with: url)
        }
    }
    
    fileprivate func playEpisode() {
//        print("play url:", episode.streamUrl)

        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
//        player.play()
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        
        return avPlayer
    }()
    
    
    //MARK: - Actions
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    
        
    //MARK: - Buttons
    @IBOutlet weak var playPause: UIButton! {
        didSet {
            
            playPause.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        } else {
            player.pause()
            playPause.setImage(UIImage(systemName: "play.fill"), for: .normal)

        }
    }
    
    @IBOutlet weak var goBackwardButton: UIButton!
    
    @IBOutlet weak var goForwardButton: UIButton!
    
}
