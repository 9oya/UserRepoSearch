//
//  SearchSearchInteractor.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchInteractor: SearchInteractorInput {

    // MARK: - Properties
    private var page = 1
    private let perPage = 20
    private var itemModels: [ItemModel]?
    private let itemModelsRelay = BehaviorRelay<[ItemModel]>(value: [ItemModel]())
    
    let disposeBag = DisposeBag()
    weak var output: SearchInteractorOutput!
    
    // MARK: - Helpers
    private func createObservableData(urlString: String) -> Observable<Data> {
        return Observable.create { (observer) -> Disposable in
            let url = URL(string: urlString)!
            do {
                let data = try Data(contentsOf: url)
                observer.onNext(data)
            } catch let error {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func createObservableDataWithType<T: Codable>(request: URLRequest, type: T.Type) -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            let dataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    observer.onError(error!)
                }
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == HTTPStatus.ok.rawValue {
                        do {
                            let resultModel = try JSONDecoder().decode(type, from: data)
                            observer.onNext(resultModel)
                        } catch let error {
                            observer.onError(error)
                        }
                    } else {
                        let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: String(decoding: data, as: UTF8.self)]) as Error
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            })
            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    
    private func downloadProfileImage(_ itemModel: ItemModel, _ cell: UserTableCell? = nil) {
        self.createObservableData(urlString: itemModel.avatar_url)
            .observeOn(MainScheduler.instance)
            .subscribe { (data) in
                if cell != nil {
                    cell!.profileImgView.image = UIImage(data: data)
                } else {
                    itemModel.avatarUrlData = data
                }
            } onError: { (error) in
                print(error.localizedDescription)
            }.disposed(by: self.disposeBag)
    }
    
    private func downloadReposCount(_ itemModel: ItemModel, _ cell: UserTableCell? = nil) {
        let request = APIRouter.getUserInfo(
            authId: BasicAuth.username.rawValue,
            authPw: BasicAuth.password.rawValue,
            username: itemModel.login)
        self.createObservableDataWithType(request: request.asURLRequest(), type: UserModel.self)
            .observeOn(MainScheduler.instance)
            .subscribe { (userModel) in
                if cell != nil {
                    cell!.reposCntLabel.text = "Number of repos: \(userModel.public_repos)"
                } else {
                    itemModel.publicReposCnt = userModel.public_repos
                }
            } onError: { (error) in
                print(error.localizedDescription)
            }.disposed(by: self.disposeBag)
    }
    
    // MARK: SearchInteractorInput
    func searchUsersWith(keyword: String, sort: SortType, order: OrderType, isScrolled: Bool) {
        page = !isScrolled ? 1 : page
        let request = APIRouter.searchUsers(
            authId: BasicAuth.username.rawValue,
            authPw: BasicAuth.password.rawValue,
            query: keyword,
            sort: sort,
            order: order,
            page: page,
            perPage: self.perPage)
        createObservableDataWithType(request: request.asURLRequest(), type: SearchModel.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (searchModel) in
                
                DispatchQueue.global().async {
                    searchModel.items.forEach {
                        self.downloadProfileImage($0)
                        self.downloadReposCount($0)
                    }
                }
                
                self.page += 1
                self.itemModels = !isScrolled ? searchModel.items : (self.itemModels != nil ? self.itemModels! + searchModel.items : searchModel.items)
                self.itemModelsRelay.accept(self.itemModels!)
                
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                if !isScrolled && self.itemModels?.count ?? 0 > 0 { self.output.scrollUserTableViewToTop() }
                self.output.finishedReloadUserTableView()
            }).disposed(by: disposeBag)
    }
    
    func getItemModelsRelay() -> BehaviorRelay<[ItemModel]> {
        return itemModelsRelay
    }
    
    func configureUserTalbeCell(cell: UserTableCell, itemModel: ItemModel) {
        
        cell.nickNameLabel.text = itemModel.login
        
        if let avatarUrlData = itemModel.avatarUrlData {
            cell.profileImgView.image = UIImage(data: avatarUrlData)
        } else {
            cell.profileImgView.image = UIImage(named: "defualtImg") // ... remove cached image
            DispatchQueue.global().async {
                self.downloadProfileImage(itemModel, cell)
            }
        }
        
        if let reposCount = itemModel.publicReposCnt {
            cell.reposCntLabel.text = "Number of repos: \(reposCount)"
        } else {
            cell.reposCntLabel.text = "Number of repos: ..." // ... remove cached text
            DispatchQueue.global().async {
                self.downloadReposCount(itemModel, cell)
            }
        }
    }
    
}
