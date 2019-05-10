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
        
        return App.Constants.tableSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return R.string.localizable.itemsTitle()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = self.presenter else {
            fatalError("presenter not present")
        }
        
        return presenter.getItemCell(titled: self.viewModel?.itemName(at: indexPath.row) ?? "",
                                     in: self.tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let itemViewModel = self.viewModel?.items[indexPath.row] {
            self.interactor?.show(item: itemViewModel)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
