//
//  ItemsPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 18.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

// View Controller must implement this
protocol ItemsViewInputProtocol {
    
    func present(viewModel: ItemsViewModel?)
    func presentNoItemsHint()
}

class ItemsPresenter {
    
    let reuseItemIdentifier: String = "reuseItemIdentifier"
    
    var viewInput: ItemsViewInputProtocol?
    var interator: ItemsInteractorInputProtocol?
}

extension ItemsPresenter: ItemsPresenterInputProtocol {
    
    func fetch() {
        
        self.interator?.fetchItems()
    }
    
    func show(items: [ItemViewModel]) {
        
        if items.count == 0 {
            self.viewInput?.presentNoItemsHint()
        } else {
            self.viewInput?.present(viewModel: ItemsViewModel(items: items))
        }
    }
    
    /// MARK :
    
    func getItemCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseItemIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: self.reuseItemIdentifier)
        }
    }
    
    /// MARK :
    
    func getItemCell(titled title: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getItemCell(for: tableView)
        
        cell.imageView?.image = R.image.pin()
        cell.textLabel?.text = title
        cell.tintColor = App.Color.tableViewCellAccessoryColor
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
