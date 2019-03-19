//
//  ItemPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// View Controller must implement this
protocol ItemViewInputProtocol {
    
    func presentUserFeedback(message: String)
}

protocol ItemPresenterInputProtocol {
    
    func saveSuccess()
    func saveFailure()
    
    func deleteSuccess()
    func deleteFailure()
}

class ItemPresenter {
    
    var viewInput: ItemViewInputProtocol?
    var interator: ItemInteractorInputProtocol?
    
    init() {
        
    }
}

extension ItemPresenter: ItemPresenterInputProtocol {
    
    func saveSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Successfully saved")
        self.interator?.showItems()
    }
    
    func saveFailure() {
        
        self.viewInput?.presentUserFeedback(message: "Could not save")
    }
    
    func deleteSuccess() {
        
        self.viewInput?.presentUserFeedback(message: "Successfully deleted")
        self.interator?.showItems()
    }
    
    func deleteFailure() {
        
        self.viewInput?.presentUserFeedback(message: "Could not delete")
    }
}
