//
//  OfflineInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 24.04.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol OfflineInteractorInputProtocol {
    
    var router: Router? { get set }

    func showContentPage()
}

class OfflineInteractor {
    
    var router: Router?
}

extension OfflineInteractor: OfflineInteractorInputProtocol {
    
    func showContentPage() {
        self.router?.popViewController()
    }
}
