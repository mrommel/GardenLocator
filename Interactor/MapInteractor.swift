//
//  MapInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 20.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol MapPresenterInputProtocol {
    
    var viewInput: MapViewInputProtocol? { get set }
    var interator: MapInteractorInputProtocol? { get set }
    
    func fetch()
    func show(items: [ItemViewModel])
}

protocol MapInteractorInputProtocol {
    
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: MapPresenterInputProtocol? { get set }
    
    func fetchItems()
}

class MapInteractor {
    
    var itemDao: ItemDaoProtocol?
    var presenterInput: MapPresenterInputProtocol?
}

extension MapInteractor: MapInteractorInputProtocol {
    
    func fetchItems() {
        
        var itemViewModels: [ItemViewModel] = []
        
        if let items = self.itemDao?.fetch() {
            for item in items {
                itemViewModels.append(ItemViewModel(item: item))
            }
        }
        
        self.presenterInput?.show(items: itemViewModels)
    }
}
