//
//  SearchSearchInteractorInput.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import Foundation
import RxCocoa

protocol SearchInteractorInput {
    
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType, isScrolled: Bool)
    
    func getItemModelsRelay() -> BehaviorRelay<[ItemModel]>
    
    func configureUserTalbeCell(cell: UserTableCell, itemModel: ItemModel)
    
}
