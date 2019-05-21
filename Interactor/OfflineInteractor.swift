//
//  OfflineInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 24.04.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol OfflineInteractorInputProtocol {

    var coordinator: Coordinator? { get set }

    func showContentPage()
}

class OfflineInteractor {

    var coordinator: Coordinator?
}

extension OfflineInteractor: OfflineInteractorInputProtocol {

    func showContentPage() {
        self.coordinator?.popViewController()
    }
}
