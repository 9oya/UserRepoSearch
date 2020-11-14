//
//  SearchSearchPresenter.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit
import RxCocoa

class SearchPresenter: SearchModuleInput, SearchViewOutput, SearchInteractorOutput {

    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!

    // MARK: SearchViewOutput
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType, isScrolled: Bool) {
        interactor.searchUsersWith(keyword: keyword, sort: sort, order: order, isScrolled: isScrolled)
    }
    
    func getItemModelsRelay() -> BehaviorRelay<[ItemModel]> {
        return interactor.getItemModelsRelay()
    }
    
    func configureUserTalbeCell(cell: UserTableCell, itemModel: ItemModel) {
        interactor.configureUserTalbeCell(cell: cell, itemModel: itemModel)
    }
    
    // MARK: SearchInteractorOutput
    func finishedReloadUserTableView() {
        view.finishedReloadUserTableView()
    }
    
    func scrollUserTableViewToTop() {
        view.scrollUserTableViewToTop()
    }
    
}
