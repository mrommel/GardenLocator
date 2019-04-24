//
//  PatchesInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol PatchesPresenterInputProtocol {

    var viewInput: PatchesViewInputProtocol? { get set }
    var interator: PatchesInteractorInputProtocol? { get set }

    func fetch()
    func show(patches: [PatchViewModel])
}

protocol PatchesInteractorInputProtocol {

    var router: Router? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var presenterInput: PatchesPresenterInputProtocol? { get set }

    func fetchPatches()

    func show(patch: PatchViewModel?)
}

class PatchesInteractor {

    var router: Router?
    var patchDao: PatchDaoProtocol?
    var presenterInput: PatchesPresenterInputProtocol?
}

extension PatchesInteractor: PatchesInteractorInputProtocol {

    func fetchPatches() {

        var patchViewModels: [PatchViewModel] = []

        if let patches = self.patchDao?.fetch() {
            for patch in patches {
                patchViewModels.append(PatchViewModel(patch: patch))
            }
        }

        self.presenterInput?.show(patches: patchViewModels)
    }

    func show(patch: PatchViewModel?) {

        self.router?.show(patch: patch)
    }
}
