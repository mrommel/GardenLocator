//
//  ItemsViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 16.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class ItemsViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    
    // Misc
    var presenter: ItemsPresenterInputProtocol?
    var interactor: ItemsInteractorInputProtocol?
    var viewModel: ItemsViewModel?
    
    let reuseIdentifier: String = "itemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.itemsTitle()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presenter?.fetch()
    }
    
    @IBAction func addItem(sender: UIView?) {
        
        self.interactor?.show(item: nil)
    }
}

extension ItemsViewController: ItemsViewInputProtocol {
    
    func present(viewModel: ItemsViewModel?) {
        
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
    
    func presentNoItemsHint() {
        
        self.viewModel = nil
        self.tableView.reloadData()
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let patchCount = self.viewModel?.items.count {
            self.tableView.restore()
            return patchCount
        }
        else {
            self.tableView.setEmptyView(title: R.string.localizable.itemsNoItemsTitle(),
                                        message: R.string.localizable.itemsNoItemsMessage())
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return R.string.localizable.itemsTitle()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let itemViewModel = self.viewModel?.items[indexPath.row] {
            cell.imageView?.image = R.image.pin()
            cell.textLabel?.text = itemViewModel.name
        }
        
        cell.tintColor = App.Color.tableViewCellAccessoryColor
        cell.accessoryType = .disclosureIndicator
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let itemViewModel = self.viewModel?.items[indexPath.row] {
            self.interactor?.show(item: itemViewModel)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
