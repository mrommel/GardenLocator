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
    let categoryDao = CategoryDao()
    let router = Router()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = App.Color.tabBarItemSelectedColor
        self.tabBar.unselectedItemTintColor = App.Color.tabBarItemNormalColor
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let mapViewController = R.storyboard.main.mapViewController()!
        let mapBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonMapTitle(), image: R.image.map_outline(), selectedImage: R.image.map())
        
        let mapInteractor = MapInteractor()
        let mapPresenter = MapPresenter()
        
        mapViewController.interactor = mapInteractor
        mapViewController.presenter = mapPresenter
        
        mapViewController.interactor?.presenterInput = mapPresenter
        mapViewController.interactor?.itemDao = itemDao
        mapViewController.interactor?.patchDao = patchDao
        
        mapViewController.presenter?.viewInput = mapViewController
        mapViewController.presenter?.interator = mapInteractor
        
        mapViewController.tabBarItem = mapBarItem
        
        // Create Tab two
        let patchesViewController = R.storyboard.main.patchesViewController()!
        let patchesBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonPatchesTitle(), image: R.image.field_outline(), selectedImage: R.image.field())
        
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
        let itemsBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonItemsTitle(), image: R.image.pin_outline(), selectedImage: R.image.pin())
        
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
        let categoriesViewController = R.storyboard.main.categoriesViewController()!
        let categoriesBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonSettingsTitle(), image: R.image.category_outline(), selectedImage: R.image.category())
        
        let categoriesInteractor = CategoriesInteractor()
        let categoriesPresenter = CategoriesPresenter()
        
        categoriesViewController.interactor = categoriesInteractor
        categoriesViewController.presenter = categoriesPresenter
        
        categoriesViewController.interactor?.presenterInput = categoriesPresenter
        categoriesViewController.interactor?.categoryDao = categoryDao
        categoriesViewController.interactor?.router = router
        
        categoriesViewController.presenter?.viewInput = categoriesViewController
        categoriesViewController.presenter?.interator = categoriesInteractor
        
        categoriesViewController.tabBarItem = categoriesBarItem
        
        // Creare Tab five
        let settingsViewController = R.storyboard.main.settingsViewController()!
        let settingsBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonSettingsTitle(), image: R.image.settings_outline(), selectedImage: R.image.settings())
        
        let settingsInteractor = SettingsInteractor()
        let settingsPresenter = SettingsPresenter()
        
        settingsViewController.interactor = settingsInteractor
        settingsViewController.presenter = settingsPresenter
        
        settingsViewController.interactor?.presenterInput = settingsPresenter
        settingsViewController.interactor?.itemDao = itemDao
        settingsViewController.interactor?.patchDao = patchDao
        settingsViewController.interactor?.router = router
        
        settingsViewController.presenter?.viewInput = settingsViewController
        settingsViewController.presenter?.interator = settingsInteractor
        
        settingsViewController.tabBarItem = settingsBarItem
        
        let controllers = [mapViewController, patchesViewController, itemsViewController, categoriesViewController, settingsViewController]

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
