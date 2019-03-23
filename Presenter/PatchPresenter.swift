//
//  PatchPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol PatchViewInputProtocol {
    
    func presentUserFeedback(message: String)
}

protocol PatchPresenterInputProtocol {
    
    func saveSuccess()
    func saveFailure()
    
    func deleteSuccess()
    func deleteFailure()
}

class PatchPresenter {
    
    var viewInput: PatchViewInputProtocol?
    var interator: PatchInteractorInputProtocol?
    
    init() {
        
    }
}

extension PatchPresenter: PatchPresenterInputProtocol {
    
    func saveSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Successfully saved")
    }
    
    func saveFailure() {
        
        self.viewInput?.presentUserFeedback(message: "Could not save")
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Successfully deleted")
        self.interator?.showPatches()
    }
    
    func deleteFailure() {
        
        self.viewInput?.presentUserFeedback(message: "Could not delete")
    }
}
