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
            miniTitleLabel.text = episode.title
            
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "" ) else { return }
            episodeImageView.sd_setImage(with: url)
            miniEpisodeImageVIew.sd_setImage(with: url)
        }
    }
    
    fileprivate func playEpisode() {

        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
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
    
    var panGesture: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        observerPlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpisodeImageView()
        }
        
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
            self.miniPlayerView.alpha = 1 + translation.y / 200
            self.maximizedStackView.alpha = -translation.y / 200
                        
        } else if gesture.state == .ended {
            
            handlePanEnded(gesture: gesture)
        }

    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                let window = UIApplication.keyWindow
                let mainTabController = window?.rootViewController as? MainTabBarController
                mainTabController?.maximazePlayerDelail(episode: nil)
                
                gesture.isEnabled = false
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }
    }
    
    @objc func handleTapMaximize() {
        let window = UIApplication.keyWindow
        let mainTabController = window?.rootViewController as? MainTabBarController
        mainTabController?.maximazePlayerDelail(episode: nil)
        
        panGesture.isEnabled = false
    }
    
    //MARK: - Actions
    @IBAction func handleDismiss(_ sender: Any) {
//        self.removeFromSuperview()
        let window = UIApplication.keyWindow
        let mainTabController = window?.rootViewController as? MainTabBarController
        mainTabController?.minimizePlayerDetail()
        
        panGesture.isEnabled = true
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
    
    @IBOutlet weak var maximizedStackView: UIStackView!

    //MARK: - Mini Player Outlets
    @IBOutlet weak var miniPlayerView: UIView! {
        didSet {
            miniPlayerView.layer.shadowRadius = 2
        }
    }
    
    @IBOutlet weak var miniEpisodeImageVIew: UIImageView!
    
    @IBOutlet weak var miniTitleLabel: UILabel!
    
    @IBOutlet weak var miniPlayPauseButton: UIButton!  {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var miniFastForwardButton: UIButton!  {
        didSet {
            miniFastForwardButton.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        }
    }
    
    
    
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
            miniPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)

            enlargeEpisodeImageView()
            
        } else {
            player.pause()
            playPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            shrinkEpisodeImageView()
            
        }
    }
    
    @IBOutlet weak var goBackwardButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var goForwardButton: UIButton!
    
}
