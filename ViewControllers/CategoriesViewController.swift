//
//  CategoriesViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit
import Rswift

class CategoriesViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    
    // Misc
    var presenter: CategoriesPresenterInputProtocol?
    var interactor: CategoriesInteractorInputProtocol?
    var viewModel: CategoriesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = R.string.localizable.categoriesTitle()
        
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
        
        self.interactor?.show(category: nil)
    }
}

extension CategoriesViewController: CategoriesViewInputProtocol {
    
    func present(viewModel: CategoriesViewModel?) {
        
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
    
    func presentNoCategoriesHint() {
        
        self.viewModel = nil
        self.tableView.reloadData()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let patchCount = self.viewModel?.categories.count {
            self.tableView.restore()
            return patchCount
        }
        else {
            self.tableView.setEmptyView(title: R.string.localizable.categoriesNoCategoriesTitle(),
                                        message: R.string.localizable.categoriesNoCategoriesMessage())
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return App.Constants.tableSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return R.string.localizable.categoriesTitle()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = self.presenter else {
            fatalError("presenter not present")
        }
        
        let categoryTitle = self.viewModel?.categoryName(at: indexPath.row) ?? ""
        return presenter.getCategoryCell(titled: categoryTitle, in: self.tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let categoryViewModel = self.viewModel?.categories[indexPath.row] {
            self.interactor?.show(category: categoryViewModel)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
