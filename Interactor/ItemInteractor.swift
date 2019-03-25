//
//  ItemInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData

protocol ItemInteractorInputProtocol {
    
    var router: Router? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var presenterInput: ItemPresenterInputProtocol? { get set }
    
    func create(item: ItemViewModel?)
    func save(item: ItemViewModel?)
    func delete(item: ItemViewModel?)
    
    func getAllPatchNames() -> [String]
    
    func showItems()
    
    func showPatchName(title: String, data: [String], selectedIndex: Int?, onSelect: @escaping (String) -> ())
    func showPatch(named patchName: String)
}

class ItemInteractor {
    
    var router: Router?
    var itemDao: ItemDaoProtocol?
    var patchDao: PatchDaoProtocol?
    var presenterInput: ItemPresenterInputProtocol?
}

extension ItemInteractor: ItemInteractorInputProtocol {
    
    func create(item: ItemViewModel?) {
        
        guard let patchName = item?.patchName else {
            self.presenterInput?.saveFailure(failure: .generic)
            return
        }
        
        guard let patch = patchDao?.get(by: patchName) else {
            self.presenterInput?.saveFailure(failure: .notFound)
            return
        }
        
        if let name = item?.name,
            let latitude = item?.latitude,
            let longitude = item?.longitude,
            let notice = item?.notice {
            
            if let saved = self.itemDao?.create(named: name, latitude: latitude, longitude: longitude, patch: patch, notice: notice) {
                if saved {
                    
                    // put identifier into model
                    if let storedItem = self.itemDao?.get(by: name) {
                        self.presenterInput?.saveSuccess(identifier: storedItem.objectID)
                    }
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure(failure: .generic)
    }
    
    func save(item: ItemViewModel?) {
        
        guard let patchName = item?.patchName else {
            self.presenterInput?.saveFailure(failure: .notFound)
            return
        }
        
        if let identifier = item?.identifier {
            
            let patch = self.patchDao?.get(by: patchName)
            
            let itemObject = self.itemDao?.get(by: identifier)
            
            itemObject?.name = item?.name
            itemObject?.latitude = item?.latitude ?? 0.0
            itemObject?.longitude = item?.longitude ?? 0.0
            itemObject?.patch = patch
            itemObject?.notice = item?.notice
            
            if let saved = self.itemDao?.save(item: itemObject) {
                if saved {
                    self.presenterInput?.saveSuccess(identifier: identifier)
                    return
                }
            }
        }
        
        self.presenterInput?.saveFailure(failure: .generic)
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
        
        self.presenterInput?.deleteFailure(failure: .generic)
    }
    
    func getAllPatchNames() -> [String] {
        
        var patchNames: [String] = []
        
        if let patches = self.patchDao?.fetch() {
            for patch in patches {
                if let patchName = patch.name {
                    patchNames.append(patchName)
                }
            }
        }
        
        return patchNames
    }
    
    func showItems() {
        // we are in the details > go back
        self.router?.popViewController()
    }
    
    func showPatchName(title: String, data: [String], selectedIndex: Int?, onSelect: @escaping (String) -> ()) {
        
        self.router?.showPatchSelection(title: title, data: data, selectedIndex: selectedIndex, onSelect: onSelect)
    }
    
    func showPatch(named patchName: String) {
        
        if let patch = self.patchDao?.get(by: patchName) {
            let patchViewModel = PatchViewModel(patch: patch)
            self.router?.show(patch: patchViewModel)
        }
    }
}
