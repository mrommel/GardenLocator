//
//  SettingsInteractor.swift
//  GardenLocator
//
//  Created by Michael Rommel on 21.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import Rswift

protocol SettingsPresenterInputProtocol {

    var viewInput: SettingsViewInputProtocol? { get set }
    var interator: SettingsInteractorInputProtocol? { get set }

    func fetch()
    func show(sections: [SettingSection])
}

protocol SettingsInteractorInputProtocol {

    var router: Router? { get set }
    var patchDao: PatchDaoProtocol? { get set }
    var itemDao: ItemDaoProtocol? { get set }
    var presenterInput: SettingsPresenterInputProtocol? { get set }

    func fetchSettings()
}

class SettingsInteractor {

    var router: Router?
    var patchDao: PatchDaoProtocol?
    var itemDao: ItemDaoProtocol?
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

                if itemsDeleted && patchesDeleted {
                    self.presenterInput?.viewInput?.showToast(message: R.string.localizable.settingsDeleteDataSuccess())
                } else {
                    self.presenterInput?.viewInput?.showToast(message: R.string.localizable.settingsDeleteDataFailure())
                }
            })
    }

    func actionGenerateData() {

        self.presenterInput?.viewInput?.askQuestion(title: "Really?",
            message: "Really create dataset?",
            buttonTitle: "Create", handler: { arg in

                guard let patchDao = self.patchDao else {
                    fatalError()
                }
                
                guard let itemDao = self.itemDao else {
                    fatalError()
                }
                
                var allCreated = true
                allCreated = allCreated && patchDao.create(named: "Gemüsebeet", latitude: 12.3, longitude: 28.2, type: 0, color: 1)
                allCreated = allCreated && patchDao.create(named: "Kartoffelbeet", latitude: 12.4, longitude: 28.2, type: 1, color: 2)
                allCreated = allCreated && patchDao.create(named: "Blumebeet", latitude: 12.4, longitude: 28.2, type: 1, color: 2)
                
                let patch0: Patch = patchDao.get(by: "Gemüsebeet")!
                let patch1: Patch = patchDao.get(by: "Kartoffelbeet")!
                let patch1: Patch = patchDao.get(by: "Kartoffelbeet")!
                
                allCreated = allCreated && itemDao.create(named: "Tomaten", latitude: 12.31, longitude: 28.2, patch: patch0, notice: "abc")
                allCreated = allCreated && itemDao.create(named: "Kartoffeln", latitude: 12.31, longitude: 28.2, patch: patch1, notice: "dabc")
                
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
