//
//  Router.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Rswift
import UIKit

class Router {
    
    let itemDao = ItemDao()
    let patchDao = PatchDao()
    let categoryDao = CategoryDao()

    func getMapViewController() -> UIViewController {
        
        let mapViewController = R.storyboard.main.mapViewController()!
        let mapBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonMapTitle(), image: R.image.map_outline(), selectedImage: R.image.map())
        
        let mapInteractor = MapInteractor()
        let mapPresenter = MapPresenter()
        
        mapViewController.interactor = mapInteractor
        mapViewController.presenter = mapPresenter
        
        mapViewController.interactor?.router = self
        mapViewController.interactor?.presenterInput = mapPresenter
        mapViewController.interactor?.itemDao = self.itemDao
        mapViewController.interactor?.patchDao = self.patchDao
        
        mapViewController.presenter?.viewInput = mapViewController
        mapViewController.presenter?.interator = mapInteractor
        
        mapViewController.tabBarItem = mapBarItem
        
        return mapViewController
    }
    
    func getPatchesViewController() -> UIViewController {
        
        let patchesViewController = R.storyboard.main.patchesViewController()!
        let patchesBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonPatchesTitle(), image: R.image.field_outline(), selectedImage: R.image.field())
        
        let patchesInteractor = PatchesInteractor()
        let patchesPresenter = PatchesPresenter()
        
        patchesViewController.interactor = patchesInteractor
        patchesViewController.presenter = patchesPresenter
        
        patchesViewController.interactor?.presenterInput = patchesPresenter
        patchesViewController.interactor?.patchDao = self.patchDao
        patchesViewController.interactor?.router = self
        
        patchesViewController.presenter?.viewInput = patchesViewController
        patchesViewController.presenter?.interator = patchesInteractor
        
        patchesViewController.tabBarItem = patchesBarItem
        
        return patchesViewController
    }
    
    func getItemsViewController() -> UIViewController {
        
        let itemsViewController = R.storyboard.main.itemsViewController()!
        let itemsBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonItemsTitle(), image: R.image.pin_outline(), selectedImage: R.image.pin())
        
        let itemsInteractor = ItemsInteractor()
        let itemsPresenter = ItemsPresenter()
        
        itemsViewController.interactor = itemsInteractor
        itemsViewController.presenter = itemsPresenter
        
        itemsViewController.interactor?.presenterInput = itemsPresenter
        itemsViewController.interactor?.itemDao = self.itemDao
        itemsViewController.interactor?.router = self
        
        itemsViewController.presenter?.viewInput = itemsViewController
        itemsViewController.presenter?.interator = itemsInteractor
        
        itemsViewController.tabBarItem = itemsBarItem
        
        return itemsViewController
    }
    
    func getCategoriesViewController() -> UIViewController {
        
        let categoriesViewController = R.storyboard.main.categoriesViewController()!
        let categoriesBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonSettingsTitle(), image: R.image.category_outline(), selectedImage: R.image.category())
        
        let categoriesInteractor = CategoriesInteractor()
        let categoriesPresenter = CategoriesPresenter()
        
        categoriesViewController.interactor = categoriesInteractor
        categoriesViewController.presenter = categoriesPresenter
        
        categoriesViewController.interactor?.presenterInput = categoriesPresenter
        categoriesViewController.interactor?.categoryDao = categoryDao
        categoriesViewController.interactor?.router = self
        
        categoriesViewController.presenter?.viewInput = categoriesViewController
        categoriesViewController.presenter?.interator = categoriesInteractor
        
        categoriesViewController.tabBarItem = categoriesBarItem
        
        return categoriesViewController
    }
    
    func getSettingsViewController() -> UIViewController {
        
        let settingsViewController = R.storyboard.main.settingsViewController()!
        let settingsBarItem = UITabBarItem(title: R.string.localizable.tabBarButtonSettingsTitle(), image: R.image.settings_outline(), selectedImage: R.image.settings())
        
        let settingsInteractor = SettingsInteractor()
        let settingsPresenter = SettingsPresenter()
        
        settingsViewController.interactor = settingsInteractor
        settingsViewController.presenter = settingsPresenter
        
        settingsViewController.interactor?.presenterInput = settingsPresenter
        settingsViewController.interactor?.itemDao = self.itemDao
        settingsViewController.interactor?.patchDao = self.patchDao
        settingsViewController.interactor?.categoryDao = self.categoryDao
        settingsViewController.interactor?.router = self
        
        settingsViewController.presenter?.viewInput = settingsViewController
        settingsViewController.presenter?.interator = settingsInteractor
        
        settingsViewController.tabBarItem = settingsBarItem
        
        return settingsViewController
    }
    
    func showOfflinePage() {
        
        if let topController = UIApplication.topViewController() {
            if let offlineViewController = R.storyboard.main.offlineViewController() {
                
                let offlineInteractor = OfflineInteractor()
                
                offlineInteractor.router = self
                
                offlineViewController.interactor = offlineInteractor
                
                topController.navigationController?.pushViewController(offlineViewController, animated: true)
            }
        }
    }
    
    func show(patch viewModel: PatchViewModel?) {
        
        if let topController = UIApplication.topViewController() {
            if let patchViewController = R.storyboard.main.patchViewController() {
                
                let patchInteractor = PatchInteractor()
                let patchPresenter = PatchPresenter()
                
                patchPresenter.interator = patchInteractor
                patchPresenter.viewInput = patchViewController
                
                patchInteractor.router = self
                patchInteractor.presenterInput = patchPresenter
                patchInteractor.patchDao = self.patchDao
                patchInteractor.itemDao = self.itemDao
                
                patchViewController.interactor = patchInteractor
                patchViewController.presenter = patchPresenter
                patchViewController.viewModel = viewModel
                
                topController.navigationController?.pushViewController(patchViewController, animated: true)
            }
        }
    }
    
    func show(item viewModel: ItemViewModel?) {
        
        if let topController = UIApplication.topViewController() {
            if let itemViewController = R.storyboard.main.itemViewController() {
                
                let itemInteractor = ItemInteractor()
                let itemPresenter = ItemPresenter()
                
                itemPresenter.interator = itemInteractor
                itemPresenter.viewInput = itemViewController
                
                itemInteractor.router = self
                itemInteractor.presenterInput = itemPresenter
                itemInteractor.itemDao = self.itemDao
                itemInteractor.patchDao = self.patchDao
                
                itemViewController.interactor = itemInteractor
                itemViewController.presenter = itemPresenter
                itemViewController.viewModel = viewModel
                
                topController.navigationController?.pushViewController(itemViewController, animated: true)
            }
        }
    }
    
    func showPatchSelection(title: String, data: [String]?, selectedIndex: Int?, onSelect: @escaping (String) -> ()) {
        
        if let topController = UIApplication.topViewController() {
            let viewController = SelectionViewController(
                title: title,
                data: data,
                selectedIndex: selectedIndex,
                onSelect: onSelect)
        
            topController.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showShapeSelection(title: String, data: [String]?, selectedIndex: Int?, onSelect: @escaping (String) -> ()) {
        
        if let topController = UIApplication.topViewController() {
            let viewController = SelectionViewController(
                title: title,
                data: data,
                selectedIndex: selectedIndex,
                onSelect: onSelect)
            
            topController.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func show(category viewModel: CategoryViewModel?, parent parentViewModel: CategoryViewModel?) {
        
        if let topController = UIApplication.topViewController() {
            if let categoryViewController = R.storyboard.main.categoryViewController() {
                
                let categoryInteractor = CategoryInteractor()
                let categoryPresenter = CategoryPresenter()
                
                categoryPresenter.interator = categoryInteractor
                categoryPresenter.viewInput = categoryViewController
                
                categoryInteractor.router = self
                categoryInteractor.presenterInput = categoryPresenter
                categoryInteractor.categoryDao = self.categoryDao
                
                categoryViewController.interactor = categoryInteractor
                categoryViewController.presenter = categoryPresenter
                categoryViewController.viewModel = viewModel
                categoryViewController.parentViewModel = parentViewModel
                
                topController.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        }
    }
    
    func popViewController() {
        
        if let topController = UIApplication.topViewController() {
            topController.navigationController?.popViewController(animated: true)
        }
    }
}
