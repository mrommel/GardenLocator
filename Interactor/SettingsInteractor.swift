//
//  SettingsInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 21.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import Rswift
import GoogleMaps

protocol SettingsPresenterInputProtocol {

    var viewInput: SettingsViewInputProtocol? { get set }
    var interator: SettingsInteractorInputProtocol? { get set }

    func fetch()
    func show(sections: [SettingSection])
    
    func getSettingCell(for settingItem: SettingItem?, in tableView: UITableView) -> UITableViewCell
}

protocol SettingsInteractorInputProtocol {

    var router: Router? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var categoryDao: CategoryDaoProtocol? { get set }
    var presenterInput: SettingsPresenterInputProtocol? { get set }

    func fetchSettings()
}

class SettingsInteractor {

    var router: Router?
    var patchDao: PatchDaoProtocol?
    var itemDao: ItemDaoProtocol?
    var categoryDao: CategoryDaoProtocol?
    var presenterInput: SettingsPresenterInputProtocol?

    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }

    func appData() -> String {

        let patchCount = self.patchDao?.fetch()?.count ?? 0
        let itemCount = self.itemDao?.fetch()?.count ?? 0

        return "Patches: \(patchCount)\nItems: \(itemCount)"
    }

    // actions

    func actionResetData() {
        self.presenterInput?.viewInput?.askQuestion(title: R.string.localizable.settingsDeleteDataQuestionTitle(),
            message: R.string.localizable.settingsDeleteDataQuestionQuestion(),
            buttonTitle: R.string.localizable.buttonDelete(), handler: { arg in

                let itemsDeleted = self.itemDao?.deleteAll() ?? false
                let patchesDeleted = self.patchDao?.deleteAll() ?? false
                let categoriesDeleted = self.categoryDao?.deleteAll() ?? false

                if itemsDeleted && patchesDeleted && categoriesDeleted {
                    self.presenterInput?.viewInput?.showToast(message: R.string.localizable.settingsDeleteDataSuccess())
                } else {
                    self.presenterInput?.viewInput?.showToast(message: R.string.localizable.settingsDeleteDataFailure())
                }
            })
    }

    func patch(named name: String, at coordinate: CLLocationCoordinate2D, type: Int64, color: Int64) -> Patch? {
        
        guard let patchDao = self.patchDao else {
            fatalError()
        }
        
        let created = patchDao.create(named: name, latitude: coordinate.latitude, longitude: coordinate.longitude, type: type, color: color)
        
        if !created {
            return nil
        }
        
        return patchDao.get(by: name)
    }
    
    func item(named name: String, at coordinate: CLLocationCoordinate2D, patch: Patch, notice: String) -> Bool {
        
        guard let itemDao = self.itemDao else {
            fatalError()
        }
        
        return itemDao.create(named: name, latitude: coordinate.latitude, longitude: coordinate.longitude, patch: patch, notice: notice)
    }
    
    func actionGenerateData() {

        self.presenterInput?.viewInput?.askQuestion(title: "Really recreate?",
            message: "Really recreate dataset?",
            buttonTitle: "Create", handler: { arg in

                var allCreated = true
                let coord = App.Constants.initialCoordinate
                
                // patches
                let patch0 = self.patch(named: "Gemüsebeet", at: coord.shiftedByMetersIn(latitudeDir: 0.0, longitudeDir: 0.0), type: 0, color: 1)
                let patch1 = self.patch(named: "Kartoffelbeet", at: coord.shiftedByMetersIn(latitudeDir: 2.0, longitudeDir: 1.0), type: 1, color: 6)
                let patch2 = self.patch(named: "Blumenbeet", at: coord.shiftedByMetersIn(latitudeDir: 4.0, longitudeDir: 6.0), type: 2, color: 4)
                
                // items
                allCreated = allCreated && self.item(named: "Tomaten", at: patch0!.coord().shiftedByMetersIn(latitudeDir: 1.0, longitudeDir: 0.0), patch: patch0!, notice: "abc")
                allCreated = allCreated && self.item(named: "Gurken", at: patch0!.coord().shiftedByMetersIn(latitudeDir: 0.0, longitudeDir: 0.5), patch: patch0!, notice: "abc")
            
                allCreated = allCreated && self.item(named: "Kartoffeln", at: patch1!.coord().shiftedByMetersIn(latitudeDir: 1.0, longitudeDir: 0.0), patch: patch1!, notice: "abc")
                allCreated = allCreated && self.item(named: "Wildkartoffeln", at: patch1!.coord().shiftedByMetersIn(latitudeDir: 0.0, longitudeDir: 0.5), patch: patch1!, notice: "abc")
                
                allCreated = allCreated && self.item(named: "Rosen", at: patch2!.coord().shiftedByMetersIn(latitudeDir: 1.0, longitudeDir: 0.0), patch: patch2!, notice: "abc")
                allCreated = allCreated && self.item(named: "Tulpen", at: patch2!.coord().shiftedByMetersIn(latitudeDir: 0.0, longitudeDir: 0.5), patch: patch2!, notice: "abc")
                allCreated = allCreated && self.item(named: "Narzissen", at: patch2!.coord().shiftedByMetersIn(latitudeDir: 1.0, longitudeDir: 0.5), patch: patch2!, notice: "abc")
                
                // categories
                let _ = self.categoryDao?.create(named: "Blumen", parent: nil)
                let category0 = self.categoryDao?.get(by: "Blumen")
                let _ = self.categoryDao?.create(named: "Sommerblumen", parent: category0)
                let _ = self.categoryDao?.create(named: "Winterblumen", parent: category0)

                let _ = self.categoryDao?.create(named: "Gemüse", parent: nil)
                let category1 = self.categoryDao?.get(by: "Gemüse")
                let _ = self.categoryDao?.create(named: "Grünes Gemüse", parent: category1)
                let _ = self.categoryDao?.create(named: "Rotes Gemüse", parent: category1)
                
                let _ = self.categoryDao?.create(named: "Obst", parent: nil)
                let category2 = self.categoryDao?.get(by: "Obst")
                let _ = self.categoryDao?.create(named: "Kernobst", parent: category2)
                let _ = self.categoryDao?.create(named: "Steinobst", parent: category2)
                
                if let item0 = self.itemDao?.get(by: "Tomaten"), let category1 = category1 {
                    item0.addToCategories(category1)
                    allCreated = allCreated && self.itemDao?.save(item: item0) ?? false
                }
                
                if allCreated {
                    self.presenterInput?.viewInput?.showToast(message: "Successfully created")
                } else {
                    self.presenterInput?.viewInput?.showToast(message: "Could not create data")
                }
            })
    }
}

extension SettingsInteractor: SettingsInteractorInputProtocol {

    func fetchSettings() {

        let item0_1 = SettingItem(icon: R.image.info(),
            title: R.string.localizable.settingsAppVersion(),
            selectionHandler: {

                self.presenterInput?.viewInput?.showError(title: R.string.localizable.settingsAppVersion(),
                    message: "\(self.version())\n\(self.appData())")
            })
        let section0 = SettingSection(title: R.string.localizable.settingsSectionApp(), items: [item0_1])

        let item1_0 = SettingItem(icon: R.image.reset(),
            title: R.string.localizable.settingsResetData(),
            selectionHandler: {

                self.actionResetData()
            })

        let item1_1 = SettingItem(icon: R.image.generate(),
            title: "Generate Data",
            selectionHandler: {

                self.actionGenerateData()
            })

        let section1 = SettingSection(title: R.string.localizable.settingsSectionData(), items: [item1_0, item1_1])

        self.presenterInput?.show(sections: [section0, section1])
    }
}
