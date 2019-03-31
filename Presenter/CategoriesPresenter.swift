//
//  CategoriesPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol CategoriesViewInputProtocol {
    
    func present(viewModel: CategoriesViewModel?)
    func presentNoCategoriesHint()
}

class CategoriesPresenter {
    
    var viewInput: CategoriesViewInputProtocol?
    var interator: CategoriesInteractorInputProtocol?
}

extension CategoriesPresenter: CategoriesPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchCategories()
    }
    
    func show(categories: [CategoryViewModel]) {
        
        if categories.count == 0 {
            self.viewInput?.presentNoCategoriesHint()
        } else {
            self.viewInput?.present(viewModel: CategoriesViewModel(categories: categories))
        }
    }
}
