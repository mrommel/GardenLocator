//
//  OfflineViewController.swift
//  GardenLocator
//
//  Created by Michael Rommel on 24.04.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
    
    // Misc
    var interactor: OfflineInteractorInputProtocol?
    
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Offline"
        
        self.networkManager.reachability?.whenReachable = { _ in
            print("Network is back")
            
            self.interactor?.showContentPage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
