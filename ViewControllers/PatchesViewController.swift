//
//  PatchesViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 16.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class PatchesViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    
    // Misc
    var presenter: PatchesPresenterInputProtocol?
    var interactor: PatchesInteractorInputProtocol?
    var viewModel: PatchesViewModel?
    
    let reuseIdentifier: String = "patchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Beete"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        let patchDao = PatchDao()
        let router = Router()
        self.interactor = PatchesInteractor()
        self.presenter = PatchesPresenter()
        
        self.interactor?.presenterInput = self.presenter
        self.interactor?.patchDao = patchDao
        self.interactor?.router = router
        
        self.presenter?.viewInput = self
        self.presenter?.interator = self.interactor

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPatch))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.fetch()
    }
    
    @IBAction func addPatch(sender: UIView?) {
        
        self.interactor?.show(patch: nil)
    }
}

extension PatchesViewController: PatchesViewInputProtocol {   
    
    func present(viewModel: PatchesViewModel?) {
        
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
    
    func presentNoPatchesHint() {
        
        self.viewModel = nil
        self.tableView.reloadData()
    }
}

extension PatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let patchCount = self.viewModel?.patches.count {
            self.tableView.restore()
            return patchCount
        }
        else {
            self.tableView.setEmptyView(title: "No patches.", message: "Your patches will be in here.")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Beete"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let patchViewModel = self.viewModel?.patches[indexPath.row] {
            cell.imageView?.image = R.image.field()
            cell.textLabel?.text = patchViewModel.name
            cell.detailTextLabel?.text = "\(patchViewModel.itemNames.count) Items"
        }
        
        cell.tintColor = App.Color.tableViewCellAccessoryColor
        cell.accessoryType = .disclosureIndicator
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let patchViewModel = self.viewModel?.patches[indexPath.row] {
            self.interactor?.show(patch: patchViewModel)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
