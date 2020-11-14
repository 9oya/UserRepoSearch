//
//  SearchSearchViewOutput.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit
import RxCocoa

protocol SearchViewOutput {

    /**
        @author 9oya
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType, isScrolled: Bool)
    
    func getItemModelsRelay() -> BehaviorRelay<[ItemModel]>
    
    func configureUserTalbeCell(cell: UserTableCell, itemModel: ItemModel)
    
}
