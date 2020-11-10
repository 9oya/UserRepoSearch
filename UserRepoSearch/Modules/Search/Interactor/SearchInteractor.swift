//
//  SearchSearchInteractor.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit
import RxSwift

class SearchInteractor: SearchInteractorInput {

    weak var output: SearchInteractorOutput!
    
    // MARK: SearchInteractorInput
//    func searchUsersWith(keyword: String, sort: SortType, order: OrderType) -> Observable<SearchModel> {
//        return Observable.create { (observer) -> Disposable in
//            var dataTask: URLSessionDataTask?
//            dataTask = URLSession(configuration: .default).dataTask(with: APIRouter.searchUsers(authId: <#T##String#>, authPw: <#T##String#>, query: <#T##String#>, sort: <#T##SortType#>, order: <#T##OrderType#>, page: <#T##Int#>, perPage: <#T##Int#>), completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
//        }
//        
//    }
}
