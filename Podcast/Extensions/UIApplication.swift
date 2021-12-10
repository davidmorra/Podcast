//
//  UIApplication.swift
//  Podcast
//
//  Created by Macbook on 12/10/21.
//

import Foundation
import UIKit

extension UIApplication {
    static let keyWindow = UIApplication.shared.connectedScenes        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
}
