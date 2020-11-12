//
//  SearchSearchPresenter.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class SearchPresenter: SearchModuleInput, SearchViewOutput, SearchInteractorOutput {

    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!

    // MARK: SearchViewOutput
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType) {
        interactor.searchUsersWith(keyword: keyword, sort: sort, order: order)
    }
    
    func resetSearchUserResult() {
        interactor.resetSearchUserResult()
    }
    
    func getNumberOfItemModels() -> Int {
        return interactor.getNumberOfItemModels()
    }
    
    func getItemModelAt(indexPath: IndexPath) -> ItemModel {
        return interactor.getItemModelAt(indexPath: indexPath)
    }
    
    // MARK: SearchInteractorOutput
    func reloadUserTableView() {
        view.reloadUserTableView()
    }
    
}
