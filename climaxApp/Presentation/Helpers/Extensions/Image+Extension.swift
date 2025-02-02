//
//  Image+Extension.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import SwiftUI

extension Image {
    /// Logo of the app
    static let appLogo = Image("climax_app_logo")
    
    /// Search icon
    static let searchIcon = Image(systemName: "magnifyingglass")
    
    /// Star unfilled icon
    static let starIcon = Image(systemName: "star")

    /// Star filled icon
    static let starFillIcon = Image(systemName: "star.fill")
    
    /// Cloud icon
    static let cloudIcon = Image(systemName: "cloud.fill")
    
    /// Cloud drizzle icon
    static let cloudDrizzleIcon = Image(systemName: "cloud.drizzle.fill")
    
    /// Cloud rain icon
    static let cloudRainIcon = Image(systemName: "cloud.rain.fill")
    
    /// Ccloud heavy rain icon
    static let cloudHeavyRainIcon = Image(systemName: "cloud.heavyrain.fill")
}
