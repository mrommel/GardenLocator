//
//  SettingsInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 21.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol SettingsPresenterInputProtocol {
    
    var viewInput: SettingsViewInputProtocol? { get set }
    var interator: SettingsInteractorInputProtocol? { get set }
    
    func fetch()
    func show(sections: [SettingSection])
}

protocol SettingsInteractorInputProtocol {
    
    var router: Router? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: SettingsPresenterInputProtocol? { get set }
    
    func fetchSettings()
}

class SettingsInteractor {
    
    var router: Router?
    var patchDao: PatchDaoProtocol?
    var itemDao: ItemDaoProtocol?
    var presenterInput: SettingsPresenterInputProtocol?
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
}

extension SettingsInteractor: SettingsInteractorInputProtocol {
    
    func fetchSettings() {

        let item0_1 = SettingItem(title: "App version", selectionHandler: {
            
            self.presenterInput?.viewInput?.showError(title: "App Version", message: self.version())
        })
        let section0 = SettingSection(title: "App", items: [item0_1])
        
        let item1_0 = SettingItem(title: "Daten zurücksetzen", selectionHandler: {
            
            self.presenterInput?.viewInput?.askQuestion(title: "Sure?", message: "Do you really want reset all your data?", buttonTitle: "Delete", handler: { arg in
                
                let itemsDeleted = self.itemDao?.deleteAll() ?? false
                let patchesDeleted = self.patchDao?.deleteAll() ?? false
                
                if itemsDeleted && patchesDeleted {
                    self.presenterInput?.viewInput?.showToast(message: "All deleted")
                } else {
                    self.presenterInput?.viewInput?.showToast(message: "Deleting failed")
                }
            })
        })
        let section1 = SettingSection(title: "Daten", items: [item1_0])
        
        self.presenterInput?.show(sections: [section0, section1])
    }
}
