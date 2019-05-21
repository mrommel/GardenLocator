//
//  PatchInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol PatchInteractorInputProtocol {

    var coordinator: Coordinator? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: PatchPresenterInputProtocol? { get set }

    func create(patch: PatchViewModel?)
    func save(patch: PatchViewModel?)
    func delete(patch: PatchViewModel?)

    func showPatchShapes(title: String, data: [String], selectedIndex: Int?, onSelect: @escaping (String) -> ())
    func showPatches()
    func showItem(named itemName: String)

    func showOfflinePage()
}

class PatchInteractor {

    var coordinator: Coordinator?
    var patchDao: PatchDaoProtocol?
    var itemDao: ItemDaoProtocol?
    var presenterInput: PatchPresenterInputProtocol?
}

extension PatchInteractor: PatchInteractorInputProtocol {

    func showOfflinePage() {
        self.coordinator?.showOfflinePage()
    }

    func create(patch: PatchViewModel?) {

        if let name = patch?.name, let latitude = patch?.latitude, let longitude = patch?.longitude, let shape = patch?.shape, let color = patch?.color {

            let type = shape.rawValue
            let colorValue = color.rawValue

            if let saved = self.patchDao?.create(named: name, latitude: latitude, longitude: longitude, type: type, color: colorValue) {
                if saved {
                    // put identifier into model
                    if let storedItem = self.itemDao?.get(by: name) {
                        self.presenterInput?.saveSuccess(identifier: storedItem.objectID)
                    }
                    return
                }
            }
        }

        self.presenterInput?.saveFailure(failure: .generic)
    }

    func save(patch: PatchViewModel?) {

        if let identifier = patch?.identifier {
            let patchObject = self.patchDao?.get(by: identifier)

            patchObject?.name = patch?.name
            patchObject?.latitude = patch?.latitude ?? 0.0
            patchObject?.longitude = patch?.longitude ?? 0.0
            patchObject?.type = patch?.shape.rawValue ?? 0
            patchObject?.colorValue = patch?.color.rawValue ?? 0

            if let saved = self.patchDao?.save(patch: patchObject) {
                if saved {
                    self.presenterInput?.saveSuccess(identifier: identifier)
                    return
                }
            }
        }

        self.presenterInput?.saveFailure(failure: .generic)
    }

    func delete(patch: PatchViewModel?) {

        if let identifier = patch?.identifier {
            let patchObject = self.patchDao?.get(by: identifier)

            if let deleted = self.patchDao?.delete(patch: patchObject) {
                if deleted {
                    self.presenterInput?.deleteSuccess()
                }
            }
        }

        self.presenterInput?.deleteFailure(failure: .generic)
    }

    func showPatchShapes(title: String, data: [String], selectedIndex: Int?, onSelect: @escaping (String) -> ()) {

        self.coordinator?.showShapeSelection(title: title, data: data, selectedIndex: selectedIndex, onSelect: onSelect)
    }

    func showPatches() {
        // we are in the details > go back
        self.coordinator?.popViewController()
    }

    func showItem(named itemName: String) {

        if let item = self.itemDao?.get(by: itemName) {
            let itemViewModel = ItemViewModel(item: item)
            self.coordinator?.show(item: itemViewModel)
        }
    }
}
