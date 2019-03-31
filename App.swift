//
//  App.swift
//  GardenLocator
//
//  Created by Michael Rommel on 16.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import GoogleMaps

class App {
    
    struct Constants {
        
        static var initialLatitude = 52.492310
        static var initialLongitude = 13.532160
        
        static var initialCoordinate = CLLocationCoordinate2D(latitude: initialLatitude, longitude: initialLongitude)
    }
    
    struct Color {
        static var navigationBarBackgroundColor: UIColor { return UIColor(red: 218, green: 99, blue: 93) } // #DA635D
        static var navigationBarTextColor: UIColor { return .white }
        
        static var tabBarItemNormalColor: UIColor { return UIColor(red: 218, green: 218, blue: 218) }
        static var tabBarItemSelectedColor: UIColor { return .white }
        
        static var viewBackgroundColor: UIColor { return .white }
        
        static var tableViewCellTextEnabledColor: UIColor { return .black }
        static var tableViewCellTextDisabledColor: UIColor { return .darkGray }
        static var tableViewCellAccessoryColor: UIColor { return UIColor(red: 218, green: 99, blue: 93) } // #DA635D
        static var tableViewCellDeleteButtonColor: UIColor { return UIColor(red: 218, green: 99, blue: 93) } // #DA635D
        
        static var refreshControlColor: UIColor { return UIColor(red: 218, green: 99, blue: 93) } // #DA635D
        
        static var alertControllerTextColor: UIColor { return .black }
        static var alertControllerBackgroundColor: UIColor { return .white }
        static var alertControllerTintColor: UIColor { return UIColor(red: 218, green: 99, blue: 93) } // #DA635D
    }
    
    struct Font {
        static var alertTitleFont: UIFont { return UIFont.systemFont(ofSize: 20.0) }
        static var alertSubtitleFont: UIFont { return UIFont.systemFont(ofSize: 14.0) }
        static var alertTextFont: UIFont { return UIFont.systemFont(ofSize: 12.0) }
        
        static var textViewFont: UIFont { return UIFont.systemFont(ofSize: 16.0) }
    }
    
    func setup() {
        
        // UITabBar
        let attributesNormal = [ NSAttributedString.Key.foregroundColor: App.Color.tabBarItemNormalColor ]
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        
        let attributesSelected = [ NSAttributedString.Key.foregroundColor: App.Color.tabBarItemSelectedColor ]
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        UITabBar.appearance().barTintColor = App.Color.navigationBarBackgroundColor
        
        // UINavigationBar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = App.Color.navigationBarBackgroundColor
        UINavigationBar.appearance().tintColor = App.Color.navigationBarTextColor
    }
}
