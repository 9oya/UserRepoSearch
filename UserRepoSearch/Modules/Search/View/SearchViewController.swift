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

class SearchViewController: UIViewController, SearchViewInput {
    
    // MARK: Properties
    var searchBar: UISearchBar!
    var tableView: UITableView!
    
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
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController {
    
    // MARK: Load views
    private func setupLayout() {
        
        // MARK: Setup view
        view.backgroundColor = .orange
        navigationItem.title = "Github Repos"
        
        // MARK: Setup sub-view properties
        searchBar = {
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            return searchBar
        }()
        tableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        // MARK: Setup UI Hierarchy
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        // MARK: DI
        
        // MARK: Setup constraints
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ]
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(searchBarConstraints + tableViewConstraints)
    }
}
