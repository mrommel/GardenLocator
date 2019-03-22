//
//  SettingsViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 16.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class SettingsViewController: UIViewController {
   
    // Views
    @IBOutlet weak var tableView: UITableView!
    
    // Misc
    var presenter: SettingsPresenterInputProtocol?
    var interactor: SettingsInteractorInputProtocol?
    var viewModel: SettingsViewModel?
    
    let reuseIdentifier: String = "settingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.tabBarButtonSettingsTitle()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.fetch()
    }
}

extension SettingsViewController: SettingsViewInputProtocol {
    
    func present(viewModel: SettingsViewModel?) {
        
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if let settingSectionsCount = self.viewModel?.sections.count {
            return settingSectionsCount
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel?.sections[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel?.sections[section].title
    }
    
    func getSettingCell() -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settingItem = self.viewModel?.sections[indexPath.section].items[indexPath.row]
        
        let cell = self.getSettingCell()
        
        cell.textLabel?.text = settingItem?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let setting = self.viewModel?.sections[indexPath.section].items[indexPath.row] {
            setting.execute()
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
