//
//  PatchesPresenter.swift
//  GardenLocator
//
//  Created by Michael Rommel on 17.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit
import Rswift

// View Controller must implement this
protocol PatchesViewInputProtocol {

    func present(viewModel: PatchesViewModel?)
    func presentNoPatchesHint()
}

class PatchesPresenter {

    let reusePatchIdentifier: String = "reusePatchIdentifier"
    
    var viewInput: PatchesViewInputProtocol?
    var interator: PatchesInteractorInputProtocol?
}

extension PatchesPresenter: PatchesPresenterInputProtocol {

    func fetch() {

        self.interator?.fetchPatches()
    }

    func show(patches: [PatchViewModel]) {

        if patches.count == 0 {
            self.viewInput?.presentNoPatchesHint()
        } else {
            self.viewInput?.present(viewModel: PatchesViewModel(patches: patches))
        }
    }
    
    /// MARK :
    
    func getPatchCell(for tableView: UITableView) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.reusePatchIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .value1, reuseIdentifier: self.reusePatchIdentifier)
        }
    }
    
    /// MARK :
    
    func getPatchCell(titled title: String, detailText: String, in tableView: UITableView) -> UITableViewCell {
        
        let cell = self.getPatchCell(for: tableView)
        
        cell.imageView?.image = R.image.field()
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detailText
        cell.tintColor = App.Color.tableViewCellAccessoryColor
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
