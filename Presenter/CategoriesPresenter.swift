//
//  CategoriesPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

// View Controller must implement this
protocol CategoriesViewInputProtocol {
    
    func present(viewModel: CategoriesViewModel?)
    func presentNoCategoriesHint()
}

class CategoriesPresenter {
    
    let reuseCategoryIdentifier: String = "reuseCategoryIdentifier"
    
    var viewInput: CategoriesViewInputProtocol?
    var interator: CategoriesInteractorInputProtocol?
}

extension CategoriesPresenter: CategoriesPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchCategories()
    }
    
    func show(categories: [CategoryViewModel]) {
        
        if categories.count == 0 {
            self.viewInput?.presentNoCategoriesHint()
        } else {
            self.viewInput?.present(viewModel: CategoriesViewModel(categories: categories))
        }
    }
    
    /// MARK:
    
    func getCategoryCell(for tableView: UITableView) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseCategoryIdentifier) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: self.reuseCategoryIdentifier)
    }
    
    /// MARK:
    
    func getCategoryCell(titled title: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getCategoryCell(for: tableView)

        cell.imageView?.image = R.image.category()
        cell.textLabel?.text = title
        cell.tintColor = App.Color.tableViewCellAccessoryColor
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
