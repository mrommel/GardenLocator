//
//  CategoriesViewModel.swift
//  GardenLocator
//
//  Created by Michael Rommel on 31.03.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class CategoriesViewModel {
    
    let categories: [CategoryViewModel]
    
    init(categories: [CategoryViewModel]) {
        self.categories = categories
    }
    
    func categoryName(at index: Int) -> String? {
        
        return self.categories[index].name
    }
}
