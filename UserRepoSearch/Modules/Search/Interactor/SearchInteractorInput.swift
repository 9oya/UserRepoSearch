//
//  SearchSearchInteractorInput.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation

protocol SearchInteractorInput {
    
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType)
    
    func resetSearchUserResult()
    
    func getNumberOfItemModels() -> Int
    
    func getItemModelAt(indexPath: IndexPath) -> ItemModel
    
    func getItemModels() -> [ItemModel]?
    
}
