//
//  CategoriesInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol CategoriesPresenterInputProtocol {
    
    var viewInput: CategoriesViewInputProtocol? { get set }
    var interator: CategoriesInteractorInputProtocol? { get set }
    
    func fetch()
    func show(categories: [CategoryViewModel])
}

protocol CategoriesInteractorInputProtocol {
    
    var router: Router? { get set }
    var categoryDao: CategoryDaoProtocol? { get set }
    var presenterInput: CategoriesPresenterInputProtocol? { get set }
    
    func fetchCategories()
    
    func show(category: CategoryViewModel?)
}

class CategoriesInteractor {
    
    var router: Router?
    var categoryDao: CategoryDaoProtocol?
    var presenterInput: CategoriesPresenterInputProtocol?
}

extension CategoriesInteractor: CategoriesInteractorInputProtocol {
    
    func fetchCategories() {
        
        var categoryViewModels: [CategoryViewModel] = []
        
        if let categories = self.categoryDao?.fetch() {
            for category in categories {
                categoryViewModels.append(CategoryViewModel(category: category))
            }
        }
        
        self.presenterInput?.show(categories: categoryViewModels)
    }
    
    func show(category: CategoryViewModel?) {
        
        self.router?.show(category: category)
    }
}
