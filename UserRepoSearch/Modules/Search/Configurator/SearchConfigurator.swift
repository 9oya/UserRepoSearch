//
//  SearchSearchConfigurator.swift
//  UserRepoSearch
//
//  Created by 9oya on 10/11/2020.
//  Copyright © 2020 9oya.com. All rights reserved.
//

import UIKit

class SearchModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? SearchViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: SearchViewController) {

        let router = SearchRouter()

        let presenter = SearchPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = SearchInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
