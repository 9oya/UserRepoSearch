//
//  SearchSearchViewController.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, SearchViewInput, UITableViewDelegate {
    
    // MARK: Properties
    var userSearchBar: UISearchBar!
    var userTableView: UITableView!
    
    var output: SearchViewOutput!
    let configurator = SearchModuleConfigurator()
    let disposeBag = DisposeBag()

    // MARK: Life cycle
    override func loadView() {
        super.loadView()
        
        // DI
        configurator.configureModuleForViewInput(viewInput: self)
        
        // Load views
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: SearchViewInput
    func setupInitialState() {
        userSearchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.output.searchUsersWith(keyword: query, sort: .repos, order: .desc)
            }).disposed(by: disposeBag)
        
        userTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func reloadUserTableView() {
        //        userTableView.reloadData()
        
        
        let itemModelRelay: BehaviorRelay<[ItemModel]> = BehaviorRelay(value: output.getItemModels()!)
        
        itemModelRelay.asObservable()
            .bind(to: userTableView.rx.items(cellIdentifier: userTableCellId, cellType: UserTableCell.self)) { idx, element, cell in
                
                
            }.disposed(by: disposeBag)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SearchViewController {
    
    // MARK: Load views
    private func setupLayout() {
        
        // MARK: Setup view
        view.backgroundColor = .orange
        navigationItem.title = "Github Repos"
        
        // MARK: Configure subview properties
        userSearchBar = {
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            return searchBar
        }()
        userTableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        // MARK: Setup UI Hierarchy
        view.addSubview(userSearchBar)
        view.addSubview(userTableView)
        
        // MARK: DI
        
        // MARK: Setup constraints
        let userSearchBarConstraints = [
            userSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            userSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ]
        let userTableViewConstraints = [
            userTableView.topAnchor.constraint(equalTo: userSearchBar.bottomAnchor, constant: 0),
            userTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            userTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            userTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(userSearchBarConstraints + userTableViewConstraints)
    }
}
