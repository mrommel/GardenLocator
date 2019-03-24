//
//  PatchPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData

enum PatchFailure {
    
    case generic
    case notFound
}

// View Controller must implement this
protocol PatchViewInputProtocol {
    
    func updateViewModel(identifier: NSManagedObjectID?)
    func presentUserFeedback(message: String)
}

protocol PatchPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?)
    func saveFailure(failure: PatchFailure)
    
    func deleteSuccess()
    func deleteFailure(failure: PatchFailure)
}

class PatchPresenter {
    
    var viewInput: PatchViewInputProtocol?
    var interator: PatchInteractorInputProtocol?
    
    init() {
        
    }
}

extension PatchPresenter: PatchPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?) {
        
        self.viewInput?.updateViewModel(identifier: identifier)
        self.viewInput?.presentUserFeedback(message: "Successfully saved")
    }
    
    func saveFailure(failure: PatchFailure) {
        
        self.viewInput?.presentUserFeedback(message: "Could not save")
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Successfully deleted")
        self.interator?.showPatches()
    }
    
    func deleteFailure(failure: PatchFailure) {
        
        self.viewInput?.presentUserFeedback(message: "Could not delete")
    }
}
