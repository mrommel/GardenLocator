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
    
    let itemDao = ItemDao()
    let patchDao = PatchDao()
    let router = Router()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = App.Color.tabBarItemSelectedColor
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let mapViewController = R.storyboard.main.mapViewController()!
        let mapBarItem = UITabBarItem(title: "Map", image: R.image.map_white(), selectedImage: R.image.map())
        
        let mapInteractor = MapInteractor()
        let mapPresenter = MapPresenter()
        
        mapViewController.interactor = mapInteractor
        mapViewController.presenter = mapPresenter
        
        mapViewController.interactor?.presenterInput = mapPresenter
        mapViewController.interactor?.itemDao = itemDao
        
        mapViewController.presenter?.viewInput = mapViewController
        mapViewController.presenter?.interator = mapInteractor
        
        mapViewController.tabBarItem = mapBarItem
        
        // Create Tab two
        let patchesViewController = R.storyboard.main.patchesViewController()!
        let patchesBarItem = UITabBarItem(title: "Patches", image: R.image.field(), selectedImage: R.image.field())
        
        let patchesInteractor = PatchesInteractor()
        let patchesPresenter = PatchesPresenter()
        
        patchesViewController.interactor = patchesInteractor
        patchesViewController.presenter = patchesPresenter
        
        patchesViewController.interactor?.presenterInput = patchesPresenter
        patchesViewController.interactor?.patchDao = self.patchDao
        patchesViewController.interactor?.router = self.router
        
        patchesViewController.presenter?.viewInput = patchesViewController
        patchesViewController.presenter?.interator = patchesInteractor
        
        patchesViewController.tabBarItem = patchesBarItem
        
        // Create Tab three
        let itemsViewController = R.storyboard.main.itemsViewController()!
        let itemsBarItem = UITabBarItem(title: "Items", image: R.image.pin(), selectedImage: R.image.pin())
        
        let itemsInteractor = ItemsInteractor()
        let itemsPresenter = ItemsPresenter()
        
        itemsViewController.interactor = itemsInteractor
        itemsViewController.presenter = itemsPresenter
        
        itemsViewController.interactor?.presenterInput = itemsPresenter
        itemsViewController.interactor?.itemDao = itemDao
        itemsViewController.interactor?.router = router
        
        itemsViewController.presenter?.viewInput = itemsViewController
        itemsViewController.presenter?.interator = itemsInteractor
        
        itemsViewController.tabBarItem = itemsBarItem
        
        // Creare Tab four
        let settingsViewController = R.storyboard.main.settingsViewController()!
        let settingsBarItem = UITabBarItem(title: "Settings", image: R.image.settings(), selectedImage: R.image.settings())
        
        settingsViewController.tabBarItem = settingsBarItem
        
        let controllers = [mapViewController, patchesViewController, itemsViewController, settingsViewController]

        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
}

extension ApplicationTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        /*if let mapViewController = viewController.children.first as? MapViewController {   
        } else if let itemsViewController = viewController.children.first as? ItemsViewController {
        } else if let patchesViewController = viewController.children.first as? PatchesViewController {
        } else if let settingsViewController = viewController.children.first as? SettingsViewController {
        }*/
    }
}
