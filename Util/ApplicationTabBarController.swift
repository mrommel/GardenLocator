//
//  ApplicationTabBarController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class ApplicationTabBarController: UITabBarController {
    
    let coordinator = Coordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = App.Color.tabBarItemSelectedColor
        self.tabBar.unselectedItemTintColor = App.Color.tabBarItemNormalColor
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let mapViewController = self.coordinator.getMapViewController()
        
        // Create Tab two
        let patchesViewController = self.coordinator.getPatchesViewController()
        
        // Create Tab three
        let itemsViewController = self.coordinator.getItemsViewController()
        
        
        // Creare Tab four
        let categoriesViewController = self.coordinator.getCategoriesViewController()
        
        // Creare Tab five
        let settingsViewController = self.coordinator.getSettingsViewController()
        
        let controllers = [mapViewController, patchesViewController, itemsViewController, categoriesViewController, settingsViewController]

        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        
        self.selectedIndex = App.getLastSelectedTabIndex()
    }
}

extension ApplicationTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        App.setLastSelectedTab(index: self.selectedIndex)
        
        /*if let mapViewController = viewController.children.first as? MapViewController {   
        } else if let itemsViewController = viewController.children.first as? ItemsViewController {
        } else if let patchesViewController = viewController.children.first as? PatchesViewController {
        } else if let settingsViewController = viewController.children.first as? SettingsViewController {
        }*/
    }
}
