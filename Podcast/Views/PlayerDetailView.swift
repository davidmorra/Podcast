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
    
    fileprivate func observerPlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime.text = time.toDisplayString()
            
            let durationTome = self.player.currentItem?.duration
            self.durationLabel.text = durationTome?.toDisplayString()
            
            self.updateCurrentTimeSlider()

        }
    }
    
    static func initFromNib() -> PlayerDetailView {
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }
    
    deinit {
        print("DeINITIALIzed memory")
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTumeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTumeSeconds / durationSeconds
        
        self.currentTimeSlider.value = Float(percentage)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observerPlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpisodeImageView()
        }
        
    }
    
    //MARK: - Actions
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = .identity
        }
    }
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.episodeImageView.transform = self.shrunkenTransform
        }
    }
    
    @IBAction func handleCurrentTimeSLiderChange(_ sender: Any) {
        
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekdTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekdTimeInSeconds, preferredTimescale: 1)
        
        player.seek(to: seekTime)
        
    }
    
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrenttime(delta: -15)
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrenttime(delta: 15)
    }
    
    fileprivate func seekToCurrenttime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)

    }
    
    @IBAction func handleVolume(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            
            episodeImageView.transform = self.shrunkenTransform
        }
    }
    @IBOutlet weak var episodeTitleLabel: UILabel! {
        didSet {
            episodeTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    
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
            enlargeEpisodeImageView()
            
        } else {
            player.pause()
            playPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            shrinkEpisodeImageView()
            
        }
    }
    
    @IBOutlet weak var goBackwardButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var goForwardButton: UIButton!
    
}
