//
//  PatchPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreData
import Rswift

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
}

extension PatchPresenter: PatchPresenterInputProtocol {
    
    func saveSuccess(identifier: NSManagedObjectID?) {
        
        self.viewInput?.updateViewModel(identifier: identifier)
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchSaveSuccess())
    }
    
    func saveFailure(failure: PatchFailure) {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchSaveFailure())
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchDeleteSuccess())
        self.interator?.showPatches()
    }
    
    func deleteFailure(failure: PatchFailure) {
        
        self.viewInput?.presentUserFeedback(message: R.string.localizable.patchDeleteFailure())
    }
}
