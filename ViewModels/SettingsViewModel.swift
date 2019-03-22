//
//  SettingsViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 21.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

struct SettingItem {
    
    let title: String
    let selectionHandler: (()->Void)?
    
    func execute() {
        if let selectionHandler = self.selectionHandler {
            selectionHandler()
        }
    }
}

struct SettingSection {
    
    let title: String
    let items: [SettingItem]
}

class SettingsViewModel {
    
    let sections: [SettingSection]
    
    init(sections: [SettingSection]) {
        
        self.sections = sections
    }
}
