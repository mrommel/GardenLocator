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
    var presenterInput: SettingsPresenterInputProtocol? { get set }
    
    func fetchSettings()
}

class SettingsInteractor {
    
    var router: Router?
    var presenterInput: SettingsPresenterInputProtocol?
}

extension SettingsInteractor: SettingsInteractorInputProtocol {
    
    func fetchSettings() {

        let item0_0 = SettingItem(title: "def")
        let item0_1 = SettingItem(title: "gtg")
        let section0 = SettingSection(title: "abc", items: [item0_0, item0_1])
        
        self.presenterInput?.show(sections: [section0])
    }
}
