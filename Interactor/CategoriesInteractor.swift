//
//  CategoriesInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

protocol CategoriesPresenterInputProtocol {
    
    var viewInput: CategoriesViewInputProtocol? { get set }
    var interator: CategoriesInteractorInputProtocol? { get set }
    
    func fetch()
    func show(categories: [CategoryViewModel])
    
    func getCategoryCell(titled title: String, in tableView: UITableView) -> UITableViewCell
}

protocol CategoriesInteractorInputProtocol {
    
    var coordinator: Coordinator? { get set }
    var categoryDao: CategoryDaoProtocol? { get set }
    var presenterInput: CategoriesPresenterInputProtocol? { get set }
    
    func fetchCategories()
    
    func show(category: CategoryViewModel?)
}

class CategoriesInteractor {
    
    var coordinator: Coordinator?
    var categoryDao: CategoryDaoProtocol?
    var presenterInput: CategoriesPresenterInputProtocol?
}

extension CategoriesInteractor: CategoriesInteractorInputProtocol {
    
    func fetchCategories() {
        
        var categoryViewModels: [CategoryViewModel] = []
        
        if let categories = self.categoryDao?.fetchRoot() {
            for category in categories {
                categoryViewModels.append(CategoryViewModel(category: category))
            }
        }
        
        self.presenterInput?.show(categories: categoryViewModels)
    }
    
    func show(category: CategoryViewModel?) {
        
        self.coordinator?.show(category: category, parent: nil)
    }
}
