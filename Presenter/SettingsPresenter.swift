//
//  SettingsPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 21.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol SettingsViewInputProtocol {
    
    func present(viewModel: SettingsViewModel?)
}

class SettingsPresenter {
    
    var viewInput: SettingsViewInputProtocol?
    var interator: SettingsInteractorInputProtocol?
}

extension SettingsPresenter: SettingsPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchSettings()
    }
    
    func show(sections: [SettingSection]) {
        
        self.viewInput?.present(viewModel: SettingsViewModel(sections: sections))
    }
}
