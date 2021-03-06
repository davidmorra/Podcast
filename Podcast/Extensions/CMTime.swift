//
//  CMTime.swift
//  Podcast
//
//  Created by Macbook on 12/7/21.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hour = minutes / 60
        
        // if episode is > 59 minutes
        let minutesNumber = minutes > 59 ? minutes % 60 : minutes
        let hourNumber = minutes > 59 ? hour : 0
                
        let timeFormatString = String(format: "%02d:%02d:%02d", hourNumber, minutesNumber, seconds)

        return timeFormatString
    }
    
}
