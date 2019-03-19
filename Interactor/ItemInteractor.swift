//
//  ItemInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol ItemInteractorInputProtocol {
    
    var router: Router? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: ItemPresenterInputProtocol? { get set }
    
    func create(item: ItemViewModel?)
    func save(item: ItemViewModel?)
    func delete(item: ItemViewModel?)
    
    func showItems()
}

class ItemInteractor {
    
    var router: Router?
    var itemDao: ItemDaoProtocol?
    var presenterInput: ItemPresenterInputProtocol?
}

extension ItemInteractor: ItemInteractorInputProtocol {
    
    func create(item: ItemViewModel?) {
        
        if let name = item?.name, let latitude = item?.latitude, let longitude = item?.longitude {
            
            if let saved = self.itemDao?.create(named: name, latitude: latitude, longitude: longitude) {
                if saved {
                    self.presenterInput?.saveSuccess()
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure()
    }
    
    func save(item: ItemViewModel?) {
        
        if let identifier = item?.identifier {
            let itemObject = self.itemDao?.get(by: identifier)
            
            itemObject?.name = item?.name
            itemObject?.latitude = item?.latitude ?? 0.0
            itemObject?.longitude = item?.longitude ?? 0.0
            
            if let saved = self.itemDao?.save(item: itemObject) {
                if saved {
                    self.presenterInput?.saveSuccess()
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure()
    }
    
    func delete(item: ItemViewModel?) {
        
        if let identifier = item?.identifier {
            let itemObject = self.itemDao?.get(by: identifier)
            
            if let deleted = self.itemDao?.delete(item: itemObject) {
                if deleted {
                    self.presenterInput?.deleteSuccess()
                }
            }
        }
        
        self.presenterInput?.deleteFailure()
    }
    
    func showItems() {
        // we are in the details > go back
        self.router?.popViewController()
    }
}
