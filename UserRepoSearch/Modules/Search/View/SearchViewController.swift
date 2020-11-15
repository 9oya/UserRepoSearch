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
    
    var keyword: String?
    var lastContentOffsetY: CGFloat = 0.0
    var isScrollToLoading: Bool = false
    
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
        
        // INPUT
        userSearchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.keyword = query
                self.output.searchUsersWith(keyword: query, sort: .repos, order: .desc, isScrolled: false)
                self.view.hideSpinner()
                self.view.showSpinner()
            }).disposed(by: disposeBag)
        
        userSearchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive { _ in
                self.userSearchBar.resignFirstResponder()
            }.disposed(by: disposeBag)
        
        userTableView.rx.contentOffset
            .subscribe(onNext: { offset in
                
                if self.lastContentOffsetY != 0 { self.userSearchBar.resignFirstResponder() }
                
                let contentSizeHeight = self.userTableView.contentSize.height
                let edgeOfScrollToLoadMore = self.userTableView.frame.size.height + offset.y + 200
                
                if (contentSizeHeight != 0) && (contentSizeHeight < edgeOfScrollToLoadMore) {
                    if self.lastContentOffsetY > offset.y {
                        // ...Scrolled up
                    } else {
                        self.lastContentOffsetY = offset.y
                        if self.isScrollToLoading || self.keyword == nil {
                            return
                        }
                        self.isScrollToLoading = true
                        self.output.searchUsersWith(keyword: self.keyword!, sort: .repos, order: .desc, isScrolled: true)
                        self.view.hideSpinner()
                        self.view.showSpinner()
                    }
                }
                
            }).disposed(by: disposeBag)
        
        userTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        // OUTPUT
        output.getItemModelsRelay().asObservable()
            .bind(to: userTableView.rx.items(cellIdentifier: userTableCellId, cellType: UserTableCell.self)) { idx, itemModel, cell in
                self.output.configureUserTalbeCell(cell: cell, itemModel: itemModel)
            }.disposed(by: disposeBag)
    }
    
    func finishedReloadUserTableView() {
        isScrollToLoading = false
        view.hideSpinner()
    }
    
    func scrollUserTableViewToTop() {
        lastContentOffsetY = 0
        userTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension SearchViewController {
    
    // MARK: Load views
    private func setupLayout() {
        
        // Setup view
        view.backgroundColor = .orange
        navigationItem.title = "Github Repos"
        
        // Configure subview properties
        userSearchBar = {
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            return searchBar
        }()
        userTableView = {
            let tableView = UITableView()
            tableView.register(UserTableCell.self, forCellReuseIdentifier: userTableCellId)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        // Setup ui Hierarchy
        view.addSubview(userSearchBar)
        view.addSubview(userTableView)
        
        // Setup ui constraints
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
