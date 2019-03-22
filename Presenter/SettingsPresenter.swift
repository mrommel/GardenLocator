//
//  SettingsPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 21.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

// View Controller must implement this
protocol SettingsViewInputProtocol {
    
    func present(viewModel: SettingsViewModel?)
    
    func showError(title: String, message: String)
    func askQuestion(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
    func showToast(message: String)
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
