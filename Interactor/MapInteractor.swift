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
    func show(items: [ItemViewModel], patches: [PatchViewModel])
}

protocol MapInteractorInputProtocol {
    
    var coordinator: Coordinator? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var presenterInput: MapPresenterInputProtocol? { get set }
    
    func fetchItems()
    func showOfflinePage()
}

class MapInteractor {

    var coordinator: Coordinator?
    var itemDao: ItemDaoProtocol?
    var patchDao: PatchDaoProtocol?
    var presenterInput: MapPresenterInputProtocol?
}

extension MapInteractor: MapInteractorInputProtocol {

    func showOfflinePage() {
        self.coordinator?.showOfflinePage()
    }
    
    func fetchItems() {
        
        var itemViewModels: [ItemViewModel] = []
        
        if let items = self.itemDao?.fetch() {
            for item in items {
                itemViewModels.append(ItemViewModel(item: item))
            }
        }
        
        var patchViewModels: [PatchViewModel] = []
        
        if let patches = self.patchDao?.fetch() {
            for patch in patches {
                patchViewModels.append(PatchViewModel(patch: patch))
            }
        }
        
        self.presenterInput?.show(items: itemViewModels, patches: patchViewModels)
    }
}
