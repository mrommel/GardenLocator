//
//  MapPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 20.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol MapViewInputProtocol {
    
    func present(viewModel: MapViewModel?)
    func presentNoItemsOrPatchesHint()
}

class MapPresenter {
    
    var viewInput: MapViewInputProtocol?
    var interator: MapInteractorInputProtocol?
}

extension MapPresenter: MapPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchItems()
    }
    
    func show(items: [ItemViewModel], patches: [PatchViewModel]) {
        
        if items.count == 0 && patches.count == 0 {
            self.viewInput?.presentNoItemsOrPatchesHint()
        } else {
            self.viewInput?.present(viewModel: MapViewModel(items: items, patches: patches))
        }
    }
}
