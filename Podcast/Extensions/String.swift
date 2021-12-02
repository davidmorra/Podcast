//
//  String.swift
//  Podcast
//
//  Created by Macbook on 12/2/21.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
}
