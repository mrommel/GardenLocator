//
//  PatchesPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol PatchesViewInputProtocol {
    
    func present(viewModel: PatchesViewModel?)
    func presentNoPatchesHint()
}

class PatchesPresenter {
    
    var viewInput: PatchesViewInputProtocol?
    var interator: PatchesInteractorInputProtocol?
}

extension PatchesPresenter: PatchesPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchPatches()
    }
    
    func show(patches: [PatchViewModel]) {
        
        if patches.count == 0 {
            self.viewInput?.presentNoPatchesHint()
        } else {
            self.viewInput?.present(viewModel: PatchesViewModel(patches: patches))
        }
    }
}
