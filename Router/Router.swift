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
    
    func show(patch viewModel: PatchViewModel?) {
        
        if let topController = UIApplication.topViewController() {
            if let patchViewController = R.storyboard.main.patchViewController() {
                
                let patchInteractor = PatchInteractor()
                let patchPresenter = PatchPresenter()
                let itemDao = ItemDao()
                let patchDao = PatchDao()
                
                patchPresenter.interator = patchInteractor
                patchPresenter.viewInput = patchViewController
                
                patchInteractor.router = self
                patchInteractor.presenterInput = patchPresenter
                patchInteractor.patchDao = patchDao
                patchInteractor.itemDao = itemDao
                
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
                let itemDao = ItemDao()
                let patchDao = PatchDao()
                
                itemPresenter.interator = itemInteractor
                itemPresenter.viewInput = itemViewController
                
                itemInteractor.router = self
                itemInteractor.presenterInput = itemPresenter
                itemInteractor.itemDao = itemDao
                itemInteractor.patchDao = patchDao
                
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
                let categoryDao = CategoryDao() // TODO: extract dao references
                
                categoryPresenter.interator = categoryInteractor
                categoryPresenter.viewInput = categoryViewController
                
                categoryInteractor.router = self
                categoryInteractor.presenterInput = categoryPresenter
                categoryInteractor.categoryDao = categoryDao
                
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
