//
//  Constants.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation

struct Constants {
    struct GeneralSizing {
        static let landscapeTopPadding: CGFloat = 30
        static let progressScaleEffect: CGFloat = 1.5
        static let shadowRadius: CGFloat = 5
    }
    
    struct Splash {
        static let appLogoWidth: CGFloat = 200
        static let splashDelay: CGFloat = 2.5
    }

    struct CityForecast {
        static let smallIconWidth: CGFloat = 20
        static let rectangleOpacity: CGFloat = 0.5
        static let appLongLogoWidth: CGFloat = 120
        static let eventImageWidth: CGFloat = 200
        static let eventLandscapeBottomPadding: CGFloat = 60
        static let textOpacity: CGFloat = 0.6
        static let weekdayWidth: CGFloat = 70
        static let cloudWidth: CGFloat = 22
        static let headerCardImageHeight: CGFloat = 12
        static let contentBottomPadding: CGFloat = 80
        static let cardCornerRadius: CGFloat = 16
        static let bottomBarPortraitPadding: CGFloat = 50
        static let landscapeBgOpacity: CGFloat = 0.7
        static let portraitBgOpacity: CGFloat = 1
        static let headerLandscapeWidth: CGFloat = 250
        static let forecastIconWidth: CGFloat = 16
        static let forecastIconOpacity: CGFloat = 0.5
        static let forecastRectangleOpacity: CGFloat = 0.3
        static let forecastWindOpacity: CGFloat = 0.5
    }
    
    struct SearchCity {
        static let smallIconWidth: CGFloat = 20
        static let opacity: CGFloat = 0.5
        static let noSearchImageWidth: CGFloat = 250
        static let noResultsImageWidth: CGFloat = 60
    }
    
    struct Favorites {
        static let smallIconWidth: CGFloat = 20
        static let backButtonIconHeight: CGFloat = 16
        static let trashIconHeight: CGFloat = 16
        static let opacity: CGFloat = 0.5
        static let noFavoritesImageWidth: CGFloat = 250
        static let deleteIconCornerRadius: CGFloat = 12
    }
}
