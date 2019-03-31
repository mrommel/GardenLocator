//
//  CategoriesViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    
    // Misc
    var presenter: CategoriesPresenterInputProtocol?
    var interactor: CategoriesInteractorInputProtocol?
    var viewModel: CategoriesViewModel?
    
    let reuseIdentifier: String = "categoriesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Categories"
        
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
            self.tableView.setEmptyView(title: "No Categories",
                                        message: "Create some")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Categories"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let categoryViewModel = self.viewModel?.categories[indexPath.row] {
            cell.imageView?.image = R.image.category()
            cell.textLabel?.text = categoryViewModel.name
        }
        
        cell.tintColor = App.Color.tableViewCellAccessoryColor
        cell.accessoryType = .disclosureIndicator
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let categoryViewModel = self.viewModel?.categories[indexPath.row] {
            self.interactor?.show(category: categoryViewModel)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
