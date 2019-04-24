//
//  ItemsPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol ItemsPresenterInputProtocol {
    
    var viewInput: ItemsViewInputProtocol? { get set }
    var interator: ItemsInteractorInputProtocol? { get set }
    
    func fetch()
    func show(items: [ItemViewModel])
}

protocol ItemsInteractorInputProtocol {
    
    var router: Router? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: ItemsPresenterInputProtocol? { get set }
    
    func fetchItems()
    
    func show(item: ItemViewModel?)
}

class ItemsInteractor {
    
    var router: Router?
    var itemDao: ItemDaoProtocol?
    var presenterInput: ItemsPresenterInputProtocol?
}

extension ItemsInteractor: ItemsInteractorInputProtocol {

    func fetchItems() {

        var itemViewModels: [ItemViewModel] = []

        if let items = self.itemDao?.fetch() {
            for item in items {
                itemViewModels.append(ItemViewModel(item: item))
            }
        }

        self.presenterInput?.show(items: itemViewModels)
    }

    func show(item: ItemViewModel?) {

        self.router?.show(item: item)
    }
}
