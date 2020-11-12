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

    // MARK: - Properties
    
    private var page = 1
    private let perPage = 20
    private var numberOfItemModels = 0
    private var itemModels: [ItemModel]?
//    private var searchModel: SearchModel?
    
    let disposeBag = DisposeBag()
    weak var output: SearchInteractorOutput!
    
    private func createSearchModelObservable(request: URLRequest) -> Observable<SearchModel> {
        return Observable.create { (observer) -> Disposable in
            let dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    observer.onError(error!)
                }
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == HTTPStatus.ok.rawValue {
                        do {
                            let searchModel = try JSONDecoder().decode(SearchModel.self, from: data)
                            observer.onNext(searchModel)
                        } catch let error {
                            observer.onError(error)
                        }
                        observer.onCompleted()
                    }
                }
            })
            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    
    // MARK: SearchInteractorInput
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType) {
        let request = APIRouter.searchUsers(
            authId: BasicAuth.username.rawValue,
            authPw: BasicAuth.password.rawValue,
            query: keyword,
            sort: sort,
            order: order,
            page: self.page,
            perPage: self.perPage)
        createSearchModelObservable(request: request.asURLRequest())
            .subscribe(onNext: { (searchModel) in
                self.page += 1
                self.numberOfItemModels += searchModel.total_count
                self.itemModels = self.itemModels != nil ? (searchModel.items != nil ? self.itemModels! + searchModel.items! : self.itemModels) : searchModel.items
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                self.output.reloadUserTableView()
            }).disposed(by: disposeBag)
    }
    
    func resetSearchUserResult() {
        page = 1
        numberOfItemModels = 0
        itemModels = nil
    }
    
    func getNumberOfItemModels() -> Int {
        return numberOfItemModels
    }
    
    func getItemModelAt(indexPath: IndexPath) -> ItemModel {
        return itemModels![indexPath.row]
    }
    
    func getItemModels() -> [ItemModel]? {
        return itemModels
    }
}

//MARK: RequestObservable class
public class RequestObservable {
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration:
                                    URLSessionConfiguration.default)
    }
    //MARK: function for URLSession takes
    public func callAPI<ItemModel: Decodable>(request: URLRequest)
    -> Observable<ItemModel> {
        //MARK: creating our observable
        return Observable.create { observer in
            //MARK: create URLSession dataTask
            let task = self.urlSession.dataTask(with: request) { (data,
                                                                  response, error) in
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try self.jsonDecoder.decode(ItemModel.self, from:
                                                                    _data)
                            //MARK: observer onNext event
                            observer.onNext(objs)
                        }
                        else {
                            observer.onError(error!)
                        }
                    } catch {
                        //MARK: observer onNext event
                        observer.onError(error)
                    }
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            //MARK: return our disposable
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
