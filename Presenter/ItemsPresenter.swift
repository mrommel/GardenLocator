//
//  ItemsPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol ItemsViewInputProtocol {
    
    func present(viewModel: ItemsViewModel?)
    func presentNoItemsHint()
}

class ItemsPresenter {
    
    var viewInput: ItemsViewInputProtocol?
    var interator: ItemsInteractorInputProtocol?
}

extension ItemsPresenter: ItemsPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchItems()
    }
    
    func show(items: [ItemViewModel]) {
        
        if items.count == 0 {
            self.viewInput?.presentNoItemsHint()
        } else {
            self.viewInput?.present(viewModel: ItemsViewModel(items: items))
        }
    }
}
