//
//  PatchInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol PatchInteractorInputProtocol {
    
    var router: Router? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: PatchPresenterInputProtocol? { get set }
    
    func create(patch: PatchViewModel?)
    func save(patch: PatchViewModel?)
    func delete(patch: PatchViewModel?)
    
    func showPatches()
    func showItem(named itemName: String)
}

class PatchInteractor {
    
    var router: Router?
    var patchDao: PatchDaoProtocol?
    var itemDao: ItemDaoProtocol?
    var presenterInput: PatchPresenterInputProtocol?
}

extension PatchInteractor: PatchInteractorInputProtocol {
    
    func create(patch: PatchViewModel?) {
        
        if let name = patch?.name {
        
            if let saved = self.patchDao?.create(named: name) {
                if saved {
                    self.presenterInput?.saveSuccess()
                    return
                }
            }
        }
        
       self.presenterInput?.saveFailure()
    }
    
    func save(patch: PatchViewModel?) {
        
        if let identifier = patch?.identifier {
            let patchObject = self.patchDao?.get(by: identifier)
        
            patchObject?.name = patch?.name
            
            if let saved = self.patchDao?.save(patch: patchObject) {
                if saved {
                    self.presenterInput?.saveSuccess()
                    return
                }
            }
        }
    
        self.presenterInput?.saveFailure()
    }
    
    func delete(patch: PatchViewModel?) {
        
        if let identifier = patch?.identifier {
            let patchObject = self.patchDao?.get(by: identifier)
                
            if let deleted = self.patchDao?.delete(patch: patchObject) {
                if deleted {
                    self.presenterInput?.deleteSuccess()
                }
            }
        }
        
        self.presenterInput?.deleteFailure()
    }
    
    func showPatches() {
        // we are in the details > go back
        self.router?.popViewController()
    }
    
    func showItem(named itemName: String) {
        
        if let item = self.itemDao?.get(by: itemName) {
            let itemViewModel = ItemViewModel(item: item)
            self.router?.show(item: itemViewModel)
        }
    }
}
